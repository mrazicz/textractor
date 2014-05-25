module Textractor
  class Analyser
    attr_reader :blocks

    def initialize block_collection
      @blocks = block_collection
    end

    def perform retrain=false
      train_network(retrain) if retrain || !defined?(@@fann)
      blocks.each {|b| b.nn_score = @@fann.run(b.data_for_neural)[0] }
      blocks
    end

    private

    def train_network retrain
      if !retrain && File.exists?("#{ROOT}/../neurals/network.fann")
        @@fann = RubyFann::Standard.new(
          filename: "#{ROOT}/../neurals/network.fann")
      else
        @@fann = RubyFann::Standard.new(
          :num_inputs=>78, :hidden_neurons=>[39, 14, 7], :num_outputs=>1)
        @@fann.set_training_algorithm(:rprop)
        @@fann.set_activation_function_layer(:gaussian_symmetric, 2)
        @@fann.set_activation_function_layer(:gaussian_symmetric, 3)
        @@fann.set_activation_function_output(:linear_piece_symmetric)
        @@fann.set_activation_steepness_layer(0.65, 1) # for 1. hidden layer
        @@fann.set_activation_steepness_layer(0.75, 2) # for 2. hidden layer
        @@fann.set_activation_steepness_layer(0.75, 3) # for 3. hidden layer
        @@fann.set_activation_steepness_output(0.8)
        3.times {|i| puts @@fann.get_activation_steepness(i+1, 2) }
        train = RubyFann::TrainData.new(
                  filename: "#{ROOT}/../train_data/train.txt")
        @@fann.train_on_data(train, 2000, 100, 0.003)
        @@fann.save("#{ROOT}/../neurals/network.fann")
      end
    end
  end

  class PostAnalyser
    attr_reader :blocks

    def initialize block_collection
      @blocks          = block_collection
      @text_start = 0
    end

    def perform
      main_text_start
      common_path
      block_neighbours
    end

    #private

    # vetsinu techto pravidel pouzivame na bloky "na hranici dobreho skore"
    #
    # WARNING: algoritmy musi byt vykonany ve zde uveden poradi aby bylo docileno
    #          co nejvetsi presnosti
    #
    # zacatek hlavniho obsahu --------------------------------------------------
    # 1. Jsou prochazeny vsechny "hlavni nadpisy" (h1 - h3) a jsou zkoumany,
    #    zda title neni podretezcem daneho nadpisu nebo opacne. Je treba si dat
    #    ale pozor na to aby nadpis nebyl nazvem stranky (logo). Toto se da ve
    #    vetsine pripadu odstinit tim, ze budeme sledovat zda max. 10 bloku pod
    #    nalezenym nadpisem se naleza dobry blok a zaden z nich neni nadpisem
    # 2. Pokud je takovy nadpis nalezen, vse pred nim je oznaceno za spatne, 
    #    resp. je snizeno skore tak aby nic nebylo nad prahem pro dobry blok.
    #    Blokum pod je skore navyseno o konstantu.
    #    Pokud nadpis nalezen neni, algoritmus konci.
    # 3. Vse pred hlavnim nadpisem bude v nasledujicich fazich ignorovano, 
    #    s vyjimkou 3 bloku pred. Cesta k hlavnimu nadpisu bude pouzita dale.
    
    def main_text_start
      title = @blocks.title.gsub(/[[:space:]]+/, ' ').downcase.strip
      hindexes = @blocks.each_index.select do |i|
        next false unless @blocks[i].name == 'h1' || @blocks[i].name == 'h2'
        block_text = @blocks[i].text.gsub(/[[:space:]]+/, ' ').downcase.strip
        block_text[title] || title[block_text]
      end.keep_if do |i|
        next false if i < 5 # first five blocks can't be main headline!
        @blocks[i+1..i+10].detect {|b| b.nn_good? && !b.headline? }
      end
      return if hindexes.empty?
      # we found some main headline, lets set some variables
      # first good headline is in most cases main headline
      @main_headline   = @blocks[hindexes.first]
      @main_headline.nn_score = 1.0
      @text_start = [hindexes.first - 3, 1].max
      # set score 0 for all blocks before main text start
      @blocks[0..@text_start-1].each {|b| b.nn_score = 0.0 }
    end
    
    # spolecne nadrazene bloky -------------------------------------------------
    # 1. prozkoumame dobre bloky a zjistime nejvetsi spolecnou cast cesty
    # 2. aby mohla byt cesta brana pod uvahu, musi ji mit alespon 3 "dobre" bloky
    # 3. u bloku na hranici zkoumame cestu, pokud ji ma "podobnou" (lisici
    #    se pouze v poslednim prvku) pak mu zvysime skore o konstantu
    # 4. cesta z predchoziho algoritmu bude vyuzita jako cesta nejlepsi a pouzita
    
    def common_path
      paths = @blocks[@text_start..-1].inject(Hash.new(0)) do |mem, b|
        mem[File.dirname(b.path)] += 1 if b.nn_good?
        mem
      end.map {|path, count| count > 2 ? path : nil }.compact.to_set

      @blocks.each do |b|
        b.nn_score += 0.1 \
          if b.nn_near_good? && paths.include?(File.dirname(b.path))
      end
    end

    # sousedici bloky ----------------------------------------------------------
    # 1. bereme bloky od zacatku dokud nenarazime na predposledni puvodne 
    #    dobry blok
    # 2. Pokud je blok "na hranici" tak:
    #    a) jej oznacime za dobry pokud:
    #      i.   max. 4 bloky pred a max. 4 bloky za je dobry prvek
    #      ii.  je to nadpis a max. 3 bloky za nasleduje dobry prvek
    #      iii. pokud pred i za (max 3 bloky od) jsou dobre elementy seznamu
    #           => takze ve vysledku cely seznam bude dobry
    #    b) oznacime je za spatny pokud:
    #      i.   pred ani za neni dobry element
    # 3. Jakmile se narazi na posledni puvodne dobry blok, algoritmus pokracuje
    #   znovu od jednicky, s tim ze postupuje od zadu, s tim, ze nyni muze 
    #   oznacit za spatny i block ktery byl puvodne dobry. Pokracuje se tak 
    #   dlouho, dokud se nenarazi na puvodne dobry blok, ktery i tento 
    #   algoritmus oznaci za dobry
    #
    
    def block_neighbours
      # from start to end
      @blocks.each {|block| block_neighbours_algorithm(block) }
      # from end to start
      #@blocks.reverse.each {|block| block_neighbours_algorithm(block) }
    end

    private

    def block_neighbours_algorithm block
      bb, ba = blocks_before(block, 6), blocks_after(block, 6)
      if block.nn_near_good? && !block.headline? && !block.list?
        wrapped_by_good(block, bb, ba)
        good_headline_somewhere(block, bb[-1..-1])
      elsif block.nn_near_good? && block.headline?
        wrapped_by_good(block, bb, ba, :nn_near_good?)
        good_somewhere(block, ba[0..2], :nn_near_good?)
      elsif !block.good? && block.list?
        bb = blocks_before_while(block, 'li')
        ba = blocks_after_while(block, 'li')
        wrapped_by_good(block, bb, ba)
      end
    end

    def good_somewhere block, _ba, good_method=:good?
      ba = (_ba || []).map(&(good_method))[0..2].to_set
      block.good! if ba.include?(true)
    end

    def good_headline_somewhere block, _ba, good_method=:good?
      ba = (_ba || []).map {|b| b.send(good_method) && b.headline? }.to_set
      block.good! if ba.include?(true)
    end

    def wrapped_by_good block, _bb, _ba, method_b=:good?, method_a=:good?
      bb = (_bb || []).map(&(method_b)).to_set
      ba = (_ba || []).map(&(method_a)).to_set
      if bb.include?(true) && ba.include?(true)
        block.good!
      else
        block.bad!
      end
    end

    def headline_neighbour block, bb, ba
      if bb[-1] && bb[-1].main_headline? && bb[-1].nn_good?
        block.good!
      elsif bb[0] && ba[0].main_headline? && ba[0].nn_good?
        block.good!
      end
    end

    def blocks_before_while block, el
      @blocks[0..block.position].reverse.inject([]) do |mem,b|
        if b.name == el && File.dirname(b.path) == File.dirname(block.path)
          (mem << b)
        else
          break mem
        end
      end
    end

    def blocks_after_while block, el
      (@blocks[block.position+1..-1] || []).inject([]) do |mem,b|
        if b.name == el && File.dirname(b.path) == File.dirname(block.path)
          (mem << b)
        else
          break mem
        end
      end
    end

    def blocks_before block, limit=5
      from, to = [block.position-limit, 0].max, [block.position-1, 0].max
      from == to ? [] : @blocks[from..to]
    end

    def blocks_after block, limit=5
      @blocks[(block.position+1)..(block.position+limit)] || []
    end
  end
end


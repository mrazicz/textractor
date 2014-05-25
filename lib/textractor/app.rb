module Textractor
  class App
    def initialize url_or_file
      if url_or_file =~ /^https?:\/\/|^www\./ then @url = url_or_file
      else @filepath = url_or_file; end
    end

    def preprocess
      if @url then html_page = HTTPClient.new(@url).get.body
      else html_page = File.open(@filepath, 'rb').read; end
      Preprocessor.new(html_page).perform
    end

    def analyse blocks, retrain=false
      train_network(retrain) if retrain || !defined?(@@fann)
      blocks.each {|b| b.nn_score = @@fann.run(b.data_for_neural)[0] }
      blocks
    end

    def dbg retrain, raw_output=false, post_analyser=true
      rslt = preprocess
      rslt = analyse(rslt, retrain) 
      if post_analyser
        pp = PostAnalyser.new(rslt)
        pp.main_text_start
        pp.common_path
        pp.block_neighbours
      end

      if raw_output
        rslt
      else
        rslt.map do |b|
          [b.nn_score, "<#{b.name}>: #{b.text}", b.features.link_count]
        end
      end
    end

    def run retrain=false
      rslt = preprocess
      train_network(retrain) if retrain || !defined?(@@fann)
      rslt
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
        #@@fann.set_activation_function_output(:gaussian_symmetric)
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
end


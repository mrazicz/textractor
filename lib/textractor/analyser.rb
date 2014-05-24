module Textractor
  class Analyser
    attr_reader :blocks

    def initialize block_collection
      @blocks = block_collecion
    end

    def perform
      #cfg = Configuration.config
      @blocks.map! do |block|
        
      end
    end
  end

  class PostAnalyser
    attr_reader :blocks

    def initialize block_collection
      @blocks = block_collection
    end

    def perform

    end

    private
    

    # vetsinu techto pravidel pouzivame na bloky "na hranici dobreho skore"
    #
    # WARNING: algoritmy musi byt vykonany ve zde uveden poradi aby bylo docileno
    #          co nejvetsi presnosti
    #
    # zacatek hlavniho obsahu --------------------------------------------------
    # 1. Jsou prochazeny vsechny "hlavni nadpisy" (h1 - h3) a jsou zkoumany,
    #    zda title neni podretezcem daneho nadpisu nebo opacne, popr. zda dany
    #    nadpis neobsahuje velkou cast title
    # 2. Pokud je takovy nadpis nalezen, vse pred nim je oznaceno za spatne, 
    #    resp. je snizeno skore tak aby nic nebylo nad prahem pro dobry blok.
    #    Blokum pod je skore navyseno o konstantu.
    #    Pokud nadpis nalezen neni, algoritmus konci.
    # 3. Vse pred hlavnim nadpisem bude v nasledujicich fazich ignorovano, 
    #    s vyjimkou 3 bloku pred. Cesta k hlavnimu nadpisu bude pouzita dale.
    
    def main_text_start

    end
    
    # spolecne nadrazene bloky -------------------------------------------------
    # 1. prozkoumame dobre bloky a zjistime nejvetsi spolecnou cast cesty
    # 2. aby mohla byt cesta brana pod uvahu, musi ji mit alespon 3 "dobre" bloky
    # 3. u bloku na hranici zkoumame cestu, pokud ji ma "podobnou" (lisici
    #    se pouze v poslednim prvku) pak mu zvysime skore o konstantu
    # 4. cesta z predchoziho algoritmu bude vyuzita jako cesta nejlepsi a pouzita
    #
    # typ obalujici znacky -----------------------------------------------------
    # 1. nadpisy, div, p, article a li, ktere maji skore mensi nez prah, obdrzi
    #    skore blizici se prahu - toto je kvuli tomu, ze neuronova sit obcas neco
    #    spatne vyhodnoti. Tato podminka se nebude vztahovat pro bloky majici
    #    skore < 0
    #
    # sousedici bloky ----------------------------------------------------------
    # 1. bereme bloky od zacatku dokud nenarazime na predposledni puvodne 
    #    dobry blok
    # 2. Pokud je blok "na hranici" tak:
    #    a) jej oznacime za dobry pokud:
    #      i.   max. 4 bloky pred a max. 4 bloky za je dobry prvek
    #      ii.  je to nadpis a max. 3 bloky za nasleduje dobry prvek
    #      iii. pokud obsahuje datum a za max. 2 bloky nasleduje nadpis
    #      iv.  pokud obsahuje datum, pred max. 2 je nadpis a max. 2 bloky za je
    #           dobry element
    #      v.   pokud pred i za jsou elementy seznamu a alespon 50% bloku z 
    #           celeho seznamu jsou dobre bloky 
    #           => takze ve vysledku cely seznam bude dobry
    #    b) oznacime je za spatny pokud:
    #      i.   pred ani za neni dobry element
    #      ii.  pred neni dobry blok (max. 5 bl.) a nasleduje nadpis (max. 2 bl)
    #           - toto je v konfliktu s tvrzenim a.iii - predchozi tvrzeni ma ale
    #             prednost
    #      iii. pred (max. 5 bloku) je dobry blok ale za uz ne a blok je u konce
    #    c) pouze zvysime skore pokud:
    #      i.   pred (kdekoliv) a za (kdekoliv) je dobry blok
    #      ii.  pokud se jedna o nadpis a za (kdekoliv) existuje alespon jeden
    #           dobry blok
    # 3. Jakmile se narazi na posledni puvodne dobry blok, algoritmus pokracuje
    #   znovu od jednicky, s tim ze postupuje od zadu, s tim, ze nyni muze 
    #   oznacit za spatny i block ktery byl puvodne dobry. Pokracuje se tak 
    #   dlouho, dokud se nenarazi na puvodne dobry blok, ktery i tento 
    #   algoritmus oznaci za dobry
    #
  end
end


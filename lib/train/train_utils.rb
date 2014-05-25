require 'digest'

module Train
  class TrainUtils
    BAD_BLOCK_NUM  = 0
    GOOD_BLOCK_NUM = 1

    def convert_pages dir_path
      path = newest_train_path
      @train_file = File.open(path, 'w')
      @train_file.puts "number_of_train_pairs number_of_inputs number_of_ouputs"
      @digest_file ||= File.open(digest_file_path, 'a')
        
      Dir["#{dir_path}/*.html"].each do |page|
        blocks = page_to_blocks(page)
        puts "======================  URL:  #{page} ============================"
        #IO.popen("open #{page}")
        skip_flag = false
        skip_until = nil
        blocks.each do |block|
          #puts(green_text("==  TEXT: #{block.text}"))
          #puts(blue_text("==  PATH: #{block.path}"))
          if exists = read_digest(block)
            if     exists == "false" then bad_block(block, nil); next
            elsif  exists == "true"  then good_block(block, nil); next
            end
          end
          if skip_flag
            bad_block(block)
            next
          end
          if skip_until && block.element.name == skip_until
            skip_until = nil
          elsif skip_until
            bad_block(block)
            next
          end
          print "==> main text? (y/n) "
          while((a = gets) !~ /^[nychdp]/); end
          if    a[0] == 'n' then bad_block(block)
          elsif a[0] == 'c' then bad_block(block); skip_flag = true
          elsif a    =~ /h\d|div|p/ then bad_block(block); skip_until = a.strip
          else  good_block(block); end
        end
      end
      # write proper header
      @train_file.close
      current_data = File.readlines(path)
      current_data[0] = "#{(current_data.size - 1) / 2} 78 1\n"
      File.open(path, 'w') {|f| f.write current_data.join }
    end

    def newest_train_file
      file = File.readlines(newest_train_path).map(&:strip)
      file[1..-1].each_slice(2).map do |(input, output)|
        [input.split.map(&:to_f), output.split]
      end
    end

    def check_against_train
      newest_train_file.each {|(i,o)| p [fann.run(i), o]; gets }
    end

    private

    def bad_block block, digest=true
      puts(red_text("== BAD BLOCK"))
      write_train_file(BAD_BLOCK_NUM, block)
      write_digest(block, false) if digest
    end

    def good_block block, digest=true
      puts(gray_text("== GOOD BLOCK"))
      write_train_file(GOOD_BLOCK_NUM, block)
      write_digest(block, true) if digest
    end

    def write_train_file output, block
      @train_file.puts block.data_for_neural.join(' ') # write inputs
      @train_file.puts output # write output
      @train_file.flush
    end

    def page_to_blocks page
      Textractor::App.new(page).preprocess
    end

    def read_digest block
      @digest_reader ||= \
        Hash[File.readlines(digest_file_path).map {|l| l.strip.split(';') }]
      digest = Digest::SHA256.hexdigest(block.element.text)
      @digest_reader[digest]
    end

    def write_digest block, good=false
      digest = Digest::SHA256.hexdigest(block.element.text)
      @digest_file.puts "#{digest};#{good}"
      @digest_file.flush
    end

    def newest_train_path
      Dir["#{File.dirname(__FILE__)}/../../train_data/train.txt"].sort.last
    end

    def digest_file_path
      "#{File.dirname(__FILE__)}/../../train_data/digest_file.txt"
    end

    def colorize_text(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def gray_text(text); colorize_text(text, 34); end
    def blue_text(text); colorize_text(text, 37); end
    def red_text(text); colorize_text(text, 31); end
    def green_text(text); colorize_text(text, 32); end
  end

end

module Textractor
  class Preprocessor
    def initialize html_page
      @html_page = html_page
      @doc       = Nokogiri::HTML(@html_page) 
      @orig_doc  = @doc
      @page_info = Hash.new
      @blocks    = Array.new
    end

    def perform
      get_title
      remove_head
      # TODO: remove more tags
      remove_tags('comment()')
      remove_tags(:script)
      remove_tags(:noscript)
      remove_tags(:object)
      remove_tags(:video)
      remove_tags(:style)
      remove_tags(:canvas)
      remove_tags(:iframe)
      remove_tags(:svg)
      remove_tags(:embed)
      # TODO: get another pages and remove boilerplate, optional!!
      
      # create block collection
      rslt = BlockCollection.new(@doc, @page_info[:title])

      # clean block collection
      remove_blank_blocks!(rslt)
      convert_whitespaces!(rslt)

      # add position to block
      rslt.each_with_index {|b, i| b.set_position(i, rslt.size) }

      # return result
      rslt
    end

    private

    def get_title
      title = @doc.at_xpath('/html/head/title')
      @page_info[:title] = title && title.text
    end

    def remove_head
      # in fact, we don't removed head, just assigning body to @doc
      # if no body is present we trying to obtain something else or whole document
      @doc = @doc.at_xpath('/html/body') || @doc.at_xpath('//body') || @doc
    end

    def remove_tags tag
      @doc.search("//#{tag}").remove 
    end

    def convert_to_blocks
      @doc.traverse {|p| }
    end

    def remove_blank_blocks! data
      data.delete_if {|block| block.text.__is_blank? } 
    end

    def convert_whitespaces! data
      data.each do |block|
        block.text.gsub!(/([[:space:]])[[:space:]]{2,}/, "\\1")
        block.text.strip!
      end
    end
  end
end


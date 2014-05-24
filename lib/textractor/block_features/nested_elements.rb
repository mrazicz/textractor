module Textractor
  class BlockFeatures
    module NestedElements
      def nested_elements
        @nested_elements ||= @block.element.xpath('./*')
      end

      def nested_elements_names
        @nested_elements_names ||= Set.new(nested_elements.map(&:name))
      end

      def nested? element_name
        nested_elements_names.include?(element_name)
      end
    end
  end
end

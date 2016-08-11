module Blocks
  class PartialRenderer < AbstractRenderer
    def initialize(builder)
      self.builder = builder
    end

    def render(partial, options={}, &block)
      overrides_and_provided_content = capture_block(builder, &block) if block_given?

      locals = Blocks.global_options.merge(init_options).merge(options).tap do |options|
        variable = options.delete(:builder_variable) || :builder
        options[variable] = builder
      end

      view.render(layout: partial, locals: locals) do |*args|
        if overrides_and_provided_content
          overrides_and_provided_content.to_str.gsub(/PLACEHOLDER_FOR_([\w]+)/) do |s|
            block_container = block_containers["#{$1}"]
            builder.render block_container.name, block_container
          end.html_safe
        end
      end
    end
  end
end
require "action_view"
require "action_controller"
require "call_with_params"
require "hashie"

module Blocks
  autoload :Base,          "blocks/base"
  autoload :Container,     "blocks/container"
  autoload :ViewAdditions, "blocks/view_additions"
  autoload :ControllerAdditions, "blocks/controller_additions"

  mattr_accessor :config
  @@config = Hashie::Mash.new
  @@config.wrap_before_and_after_blocks = false
  @@config.use_partials = false
  @@config.partials_folder = "blocks"
  @@config.skip_applies_to_surrounding_blocks = false

  # Default way to setup Blocks
  def self.setup
    yield config
  end
end

if defined?(Rails)
  if Rails::VERSION::MAJOR >= 6
    ActiveSupport.on_load(:action_view_base) do
      ActionView::Base.send :include, Blocks::ViewAdditions
    end
    ActiveSupport.on_load(:action_controller_base) do
      ActionController::Base.send :include, Blocks::ControllerAdditions
    end
  else
    ActionView::Base.send :include, Blocks::ViewAdditions
    ActionController::Base.send :include, Blocks::ControllerAdditions
  end
end

require "rails/engine"

module Aha
  module ColorPicker
    class Engine < Rails::Engine
      initializer "setup for rails" do
        # We just do this so Rails knows we have sweet, sweet assets to use
      end
    end
  end
end
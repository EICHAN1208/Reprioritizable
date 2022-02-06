module Reprioritizable
  class Railtie < ::Rails::Railtie
    initializer 'reprioritizable' do
      ActiveSupport.on_load :action_view do
        require 'reprioritizable/view_helpers/action_view'
      end
    end
  end
end

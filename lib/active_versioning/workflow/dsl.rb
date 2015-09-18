module ActiveVersioning
  module Workflow
    module DSL
      def show_version(options = {}, &block)
        config.set_page_presenter :show_version, ::ActiveAdmin::PagePresenter.new(options, &block)
      end
    end
  end
end

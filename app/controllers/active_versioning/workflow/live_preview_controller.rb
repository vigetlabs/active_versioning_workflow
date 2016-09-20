module ActiveVersioning
  module Workflow
    class LivePreviewController < ApplicationController
      def show
        render layout: false
      end
    end
  end
end

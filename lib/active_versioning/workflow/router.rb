module ActiveVersioning
  module Workflow
    module Router
      def versioned_routes(*models)
        models.each do |name|
          resources name.to_sym, only: [] do
            resources :versions, only: [:index, :show]
          end
        end
      end
    end
  end
end

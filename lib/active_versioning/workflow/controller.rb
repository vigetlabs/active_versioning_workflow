module ActiveVersioning
  module Workflow
    module Controller
      def self.included(dsl)
        dsl.instance_eval do
          member_action :commit, method: :put do
            if resource.commit(commit_params)
              # We need to reload the resource by ID, in case the resource uses
              # something other than id for the param and it has changed
              set_resource_ivar(resource.class.find(resource.id))

              redirect_to resource_path, notice: I18n.t('active_versioning.notices.commit')
            else
              # FIXME: In what ways can this fail?
              #:nocov:
              redirect_to resource_path, alert: I18n.t('active_versioning.errors.commit')
              #:nocov:
            end
          end

          member_action :create_draft, method: :post do
            if resource.create_draft_from_version(params[:version_id])
              redirect_to edit_resource_path,
                notice: I18n.t('active_versioning.notices.create_draft_from_version')
            else
              # FIXME: In what ways can this fail?
              #:nocov:
              redirect_to [active_admin_namespace.name, resource, :versions],
                alert: I18n.t('active_versioning.errors.create_draft_from_version')
              #:nocov:
            end
          end

          member_action :discard_draft, method: :delete do
            resource.destroy_draft
            redirect_to resource_path, notice: I18n.t('active_versioning.notices.discard_draft')
          end

          controller do
            before_action :assign_version_params, only: [:create, :update]
            before_action :set_draft_as_resource, only: [:edit, :update, :commit, :preview]

            private

            def renderer_for(action)
              if action == :show
                ShowResource
              else
                super
              end
            end

            # `resource_params` is an Array where the first element is the permitted
            # params and the next element is a role. These params are splatted into a
            # build method within Inherited Resources -- a remnant of Rails 3
            # `attr_accessible` method. This method will modify that first parameter
            # by merging in the version author.
            def assign_version_params
              resource_params.first.merge!(version_author: committer)
            end

            def set_draft_as_resource
              set_resource_ivar(resource.current_draft)
            end

            def committer
              current_admin_user.email
            end

            def commit_params
              params.permit(:commit_message).merge(committer: committer)
            end
          end
        end
      end
    end
  end
end

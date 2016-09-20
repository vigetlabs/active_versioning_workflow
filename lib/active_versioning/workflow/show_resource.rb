module ActiveVersioning
  module Workflow
    class ShowResource < ::ActiveAdmin::Views::Pages::Show
      include ActiveVersioning::Workflow::PreviewLink

      def main_content
        instance_exec(resource, &show_block)
      end

      def version_attributes_panel(version, &block)
        args = if version.live?
          [I18n.t('active_versioning.panels.committed_version'), id: 'committed-panel']
        else
          [I18n.t('active_versioning.panels.current_draft'), id: 'current-draft-panel']
        end

        panel(*args) do
          if version.live?
            header_action(versions_link)
          else
            header_action(discard_link)
            header_action(commit_link)
            header_action(preview_link)
            header_action(edit_link)

            render 'commit_form'
          end

          instance_eval(&block)
        end
      end

      def committed_version_panels
        instance_exec(resource, &version_block)
      end

      def current_draft_panels
        if resource.current_draft?
          instance_exec(resource.current_draft, &version_block)
        else
          blank_slate(draft_blank_slate_content)
        end
      end

      def committed_version_column
        column class: 'committed-version-column column' do
          committed_version_panels
        end
      end

      def current_draft_column
        column class: 'current-draft-column column' do
          current_draft_panels
        end
      end

      private

      def show_block
        config.block || default_show_block
      end

      def version_config
        active_admin_config.get_page_presenter(:show_version)
      end

      def version_block
        version_config.block
      end

      #:nocov:
      def default_show_block
        proc do
          columns do
            committed_version_column

            current_draft_column
          end
        end
      end
      #:nocov:

      def draft_blank_slate_content
        [
          I18n.t('active_versioning.helpers.blank_slate'),
          draft_blank_slate_link
        ].compact.join(' ')
      end

      def draft_blank_slate_link
        link_to I18n.t('active_versioning.links.blank_slate'), [:edit, active_admin_namespace.name, resource]
      end

      def versions_link
        link_to I18n.t('active_versioning.links.view_versions'), [active_admin_namespace.name, resource, :versions]
      end

      def commit_link
        link_to I18n.t('active_versioning.links.commit'), '#', class: 'commit-link'
      end

      def edit_link
        link_to I18n.t('active_versioning.links.edit'), [:edit, active_admin_namespace.name, resource], class: 'edit-link'
      end

      def preview_link
        return '' unless ActiveVersioning::Workflow.previewable?(resource)

        preview_link_for(resource)
      end

      def discard_link
        link_to I18n.t('active_versioning.links.discard_draft'), [:discard_draft, active_admin_namespace.name, resource], {
          class:  'discard-link',
          method: :delete,
          data:   { confirm: I18n.t('active_versioning.confirmations.discard_draft') }
        }
      end
    end
  end
end

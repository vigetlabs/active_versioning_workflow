ActiveAdmin.register Version do
  config.sort_order    = 'committed_at_desc'
  config.batch_actions = false

  navigation_menu :default

  menu false

  actions :index, :show

  filter :committer_cont,      label: 'Committer'
  filter :commit_message_cont, label: 'Commit Message'
  filter :committed_at

  index download_links: false do
    column :committed_at
    column :committer, sortable: false
    column :commit_message, sortable: false

    actions do |version|
      link_to t('active_versioning.links.create_draft_from_version'),
        [:create_draft, active_admin_namespace.name, version.versionable, { version_id: version }],
        method: :post,
        data: { confirm: t('active_versioning.confirmations.create_draft_from_version') }
    end
  end

  show title: :to_s

  controller do
    ActiveVersioning.versioned_models.each do |model|
      belongs_to model.name.underscore.gsub('/', '_').to_sym, class_name: model.name, polymorphic: true, finder: :find_by_id!
    end

    private

    def renderer_for(action)
      if action == :show
        ActiveVersioning::Workflow::ShowVersion
      else
        super
      end
    end
  end
end

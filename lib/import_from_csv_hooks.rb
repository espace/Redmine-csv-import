class ImportFromCsvHooks < Redmine::Hook::ViewListener
  render_on :view_projects_show_sidebar_bottom, :partial => 'import_issues_from_csv'
end

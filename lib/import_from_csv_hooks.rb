class ImportFromCsvHooks < Redmine::Hook::ViewListener
  render_on :view_issues_sidebar_issues_bottom, :partial => 'import_issues_from_csv'
end

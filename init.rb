require 'redmine'
# Hooks
require_dependency 'import_from_csv_hooks'

Redmine::Plugin.register :redmine_import_from_csv do
  name 'Redmine Import From Csv plugin'
  author 'Basayel Said'
  description 'As a TL, can upload csv file with stories to automatically add stories'
  version '0.0.1'
  permission :import_from_csv, {:import_from_csv => [:index, :csv_import]}, :public => true
  #menu :project_menu, :import_from_csv, { :controller => 'import_from_csv', :action => 'index' }, :caption => 'Import from CSV', :after => :activity, :param => :project_id
end

Redmine::MenuManager.map :project_menu do |menu|
  menu.push :import_from_csv, { :controller => 'import_from_csv', :action => 'index' }, :caption => 'Import from CSV', :after => :activity, :param => :project_id
end

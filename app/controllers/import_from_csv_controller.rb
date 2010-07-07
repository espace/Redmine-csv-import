class ImportFromCsvController < ApplicationController
  before_filter :get_project
  menu_item :import_from_csv
  require 'csv'
  def index
    respond_to do |format|
      format.html
    end
  end
  
  def csv_import
    begin
      @parsed_file=CSV::Reader.parse(params[:dump][:file])
      n=0
      @parsed_file.each  do |row|
        if row.size!=4
          flash[:error]=l(:error_no_default_issue_status)
          return
        end
        issue=Issue.new
        issue.project=@project
        issue.author=User.current
        #issue.status=IssueStatus.default
        issue.tracker=@project.trackers.find_by_name("Story")
        issue.text_id=row[0]
        issue.subject=row[1]
        issue.description=row[2]
        issue.estimated_hours=row[3]
        if issue.save
          n=n+1
        end
      end
    rescue CSV::IllegalFormatError
      flash[:error]=l(:error_bad_csv_format)
      redirect_to :controller=>"import_from_csv",:action=>"index",:project_id=>@project.id
      return
    end
    flash[:notice]="CSV Import Successful,  #{n} new issues have been created"
    redirect_to :controller=>"issues",:action=>"index",:project_id=>@project.id
  end
  
  def get_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
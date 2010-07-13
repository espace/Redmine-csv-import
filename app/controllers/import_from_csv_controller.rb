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
      n=0
      count=0
      tracker=@project.trackers.find(params[:dump][:tracker_id])
      parsed_file=CSV::Reader.parse(params[:dump][:file])
      parsed_file.each_with_index  do |row,index|
        next if index==0
        if row.size!=4
          redirect_with_error l(:error_bad_csv_format),@project
          return
        end
        text_id=row[0];subject=row[1]
        description=row[2];estimated_hrs=row[3]
        issue=Issue.new
        issue.project=@project
        issue.author=User.current
        issue.tracker=tracker
        issue.text_id=text_id
        issue.subject=subject
        issue.description=(subject.nil? ? "" : subject)+ "\n\nh3. Notes\n\n" + (description.nil? ? "" : description)   
        issue.estimated_hours=estimated_hrs.to_f * params[:dump][:daily_working_hrs].to_f unless estimated_hrs.blank? and params[:dump][:daily_working_hrs].blank?
        puts ">>>>>>>> Issue Valid? : #{issue.valid?}...#{issue.errors.full_messages.inspect}"
        if issue.save
          n=n+1
        end
        count=count+1
      end
    rescue CSV::IllegalFormatError=>e
      redirect_with_error e.message,@project
      return
    end
    if n==count
      flash[:notice]="CSV Import Successful,  #{n} new issues have been created"
    else
      flash[:error]="#{n} out of #{count} new issues have been created"
    end
    redirect_to :controller=>"issues",:action=>"index",:project_id=>@project.id
  end
  
  def redirect_with_error(err,project)
    flash[:error]=err
    redirect_to :controller=>"import_from_csv",:action=>"index",:project_id=>project.id
  end
  
  def get_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
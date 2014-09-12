# -*- coding: utf-8 -*-
require 'zip/zip'
require 'zip/zipfilesystem'

class ExportVolunteers
  @queue = :volunteers_excel 
  def self.perform(params, email, sort_column, sort_direction) 
    archive = "#{Rails.root.to_s}/public/excel_reports/volunteers.zip"
    book_limit = 6000
    sheet_limit = 2000
    FileUtils.rm archive, force: true
    Zip::ZipFile.open(archive, 'w') do |zipfile|
      book_counter = 1
      from_date = Date.strptime("#{params["from_date"]["year"]}-#{params["from_date"]["month"]}-#{params["from_date"]["day"]}") if params["from_date"] && params["from_date"].keys.all?{|k| !params["from_date"][k].blank?}
      to_date   = Date.strptime("#{params["to_date"]["year"]  }-#{params["to_date"]["month"]  }-#{params["to_date"]["day"]  }") if params["to_date"]   && params["to_date"].keys.all?  {|k| !params["to_date"][k].blank?}
      volunteers = params["id"].blank? ? Volunteer.order(sort_column + ' ' + sort_direction) : Activity.find(params["id"]).volunteers
      volunteers = volunteers.for_activity_category(params["volunteer_activity_category_id"]) unless params["volunteer_activity_category_id"].blank?
      volunteers = volunteers.where("branch_id" => params["volunteer_branch_id"]) unless params["volunteer_branch_id"].blank?
      volunteers = volunteers.where("activities_authority_status" => params["activities_authority_status"]) unless params["activities_authority_status"].blank?
      volunteers = volunteers.where('created_at >= ?', from_date) if from_date
      volunteers = volunteers.where('created_at <= ?', to_date + 1.day) if to_date
      volunteers = volunteers.search("#{params["keyword"].strip}:*") unless params["keyword"].blank?
      volunteers.find_in_batches(batch_size: book_limit) do |volunteers_block|
        block_sum = volunteers_block.count
        serial_number = 1 + (book_limit * (book_counter - 1))
        book_name = volunteers.count > book_limit ? "volunteers #{book_counter}" : "volunteers"
        sheet_name = block_sum > sheet_limit ? "#{serial_number} - #{(book_limit * (book_counter - 1)) + (sheet_limit)}" : "1 - #{block_sum}"
        reporter = Reporter.new book_name, sheet_name
        reporter.report_volunteers volunteers_block, serial_number
        reporter.write_file
        zipfile.add("#{book_name}.xls", File.open("#{Rails.root.to_s}/public/excel_reports/#{book_name}.xls"))
        book_counter = book_counter + 1      
      end   
    end

    Mailer.volunteers_report("#{Rails.root.to_s}/public/excel_reports/volunteers.zip", email).deliver!
  end
end
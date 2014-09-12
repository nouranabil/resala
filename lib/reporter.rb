# -*- coding: utf-8 -*-
class Reporter
  def initialize filename, sheet_name
    Spreadsheet.client_encoding = 'UTF-8'
    @book = Spreadsheet::Workbook.new
    Dir.mkdir("#{Rails.root.to_s}/public/excel_reports") unless Dir.exists?("#{Rails.root.to_s}/public/excel_reports")
    @sheet = @book.create_worksheet :name => sheet_name
    @path = "#{Rails.root.to_s}/public/excel_reports/#{filename}.xls"
    
    @sheet.row(0).height = 20
    format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 10
    @sheet.row(0).default_format = format
    bold = Spreadsheet::Format.new :weight => :bold
    #4.times do |x| @sheet.row(x + 1).set_format(0, bold) end
  end

  attr_reader :path
  
  def report_volunteers volunteers, initial_number
    sheet_counter = 1
    serial_number = initial_number
    sheet_limit = 2000
    volunteers.in_groups_of(sheet_limit) do |row|
      next if row.compact.empty?
      sum = row.compact.size
      @sheet = @book.create_worksheet name: "#{serial_number} - #{(initial_number-1) + sum + (sheet_limit * (sheet_counter - 1))}" if sheet_counter > 1
      starter_column = 0
      exported_header = ['ID', 'الاسم','تاريخ التسجيل','أدمن فى فيسبوك','البريد الإلكترونى',
                        'النوع','تاريخ الميلاد','السماح بنشر تحديثات على فيسبوك','أقرب فرع','الأنشطة الخيرية','موبايل','متخرج',
                        'المهنة','جهة العمل','الجامعة','السنة الدراسية','مستعد للتبرع بالدم','فصيلة الدم',
                        'نبذة عن المتطوع','استقبال التحديثات على البريد الإلكترونى','الأيام المتاحة للتطوع','موقوف',
                        'مسموح له بتنظيم أعمال تطوعية','عدد الأعمال التطوعية المشترك فيها','مشاركات سابقة فى رسالة',
                        'عدد الساعات الكلى المتطوع به','أيام محددة']
      format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 10,
                                     :horizontal_align => :center
      (0..26).each do |i|
        @sheet[0, starter_column + i] = exported_header[i]
      end
      (0..26).each do |i|
        @sheet.row(0).set_format(starter_column + i, format)
      end
      row.each_with_index do |v,index|
        print '.'
        if v.present?
          @sheet[index+1, starter_column] = v.id
          @sheet[index+1, starter_column + 1] = v.name
          @sheet[index+1, starter_column + 2] = v.created_at.to_date
          @sheet[index+1, starter_column + 3] = v.facebook_page_admin ? "نعم": "لا" 
          @sheet[index+1, starter_column + 4] = v.email
          @sheet[index+1, starter_column + 5] = v.gender=='M' ? "ذكر": v.gender=='F' ? "أنثى":""
          @sheet[index+1, starter_column + 6] = v.date_of_birth
          @sheet[index+1, starter_column + 7] = v.post_updates_to_facebook ? "نعم": "لا"
          @sheet[index+1, starter_column + 8] = v.branch.name
          @sheet[index+1, starter_column + 9] = v.activity_categories.collect(&:name).join("\n") 
          @sheet[index+1, starter_column + 10] = v.mobile 
          @sheet[index+1, starter_column + 11] = (v.graduated ? "نعم": "لا")
          @sheet[index+1, starter_column + 12] = v.profession
          @sheet[index+1, starter_column + 13] = v.company
          @sheet[index+1, starter_column + 14] = v.university
          @sheet[index+1, starter_column + 15] = v.school_year
          @sheet[index+1, starter_column + 16] = v.blood_donation ? "نعم": "لا" 
          @sheet[index+1, starter_column + 17] = v.blood_type
          @sheet[index+1, starter_column + 18] = v.bio
          @sheet[index+1, starter_column + 19] = v.get_activities_updates
          @sheet[index+1, starter_column + 20] = v.available_days_names
          @sheet[index+1, starter_column + 21] = v.suspended ? "نعم": "لا"
          @sheet[index+1, starter_column + 22] = v.activities_authority_status ? I18n.t("activities_authority_status.status_name_#{v.activities_authority_status}") : "لم يتم إرسال طلب"
          @sheet[index+1, starter_column + 23] = v.accepted_activities_requests_count
          @sheet[index+1, starter_column + 24] = v.existing_role
          @sheet[index+1, starter_column + 25] = v.activities_hours
          @sheet[index+1, starter_column + 26] = v.limited_days
          serial_number = serial_number + 1
        end
      end
      sheet_counter = sheet_counter + 1
    end    
  end
  
  def report_donations donations
    @sheet.update_row 0,'ID','اسم المتبرع','الهاتف','البريد الإلكترونى','المبلغ','تاريخ التبرع','النشاط الخيرى'
    donations.each_with_index do |d,index|
      @sheet.update_row index+1, d.id, d.donator_name, d.phone, d.email, d.amount, d.created_at.to_date, d.activity_category ? d.activity_category.name : ""
    end
  end
  
  def report_donation_requests donation_requests
    @sheet.update_row 0,'ID','اسم المتبرع','العنوان','رقم الهاتف','موبايل','البريد الإلكترونى','المحافظة','المبلغ','يتم الدفع كل','تاريخ طلب التبرع','تمت مراجعته','ملاحظات','الأنشطة الخيرية المراد التبرع لها'
    donation_requests.each_with_index do |d,index|
      @sheet.update_row index+1, d.id, d.name, d.address, d.phone, d.mobile, d.email, d.city ? d.city.name : "",
                                 d.amount, d.amount_period, d.created_at.to_date, d.reviewed ? "نعم": "لا"  ,
                                 d.notes,d.activity_categories.collect(&:name).join(',')
    end
  end
  
  def write_file
    @book.write @path
  end
end
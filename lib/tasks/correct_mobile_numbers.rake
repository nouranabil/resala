class FixedMobilesReportMailer < ActionMailer::Base
  #include Resque::Mailer
  layout 'email'
  default :from => "no-reply@resala.org"
  
  def report_email(log)
    mail(:to => ['sulsubeel@yahoo.com','yaser.alashry@espace.com.eg'],
         :subject => "report about users whose numbers were modified",
         :body => log.join("\n"))
  end
end

def fix_number(user,number,prefix,new_prefix,num_length,log)
  if number.start_with?(prefix) && number.length == num_length
    new_number = number.sub( prefix , new_prefix )
    user.update_attribute(:mobile,new_number)
    log_record = "user ##{user.id} : Mobile changed from #{number} to #{new_number}" 
    puts log_record
    log << log_record
    return true
  end
  return false
end 

desc "Corrects mobile numbers for users after the recent modifications"
task "correct_mobile_numbers" => :environment do
  #I18n.locale = 'ar'
  log = []
  invalids = []
  User.select([:id,:mobile]).each do |user|
    mob = user.mobile
    # TODO remove spaces, dashes and special characters inside the number !
    # Handle mobile = nil (for admins)
    next if mob.blank?
    
    # mobinil :
    if    fix_number(user,mob,'012','0122',10,log)
    elsif fix_number(user,mob,'017','0127',10,log)
    elsif fix_number(user,mob,'018','0128',10,log)
    elsif fix_number(user,mob,'0150','0120',11,log)
    # vofafone :
    elsif fix_number(user,mob,'010','0100',10,log)
    elsif fix_number(user,mob,'016','0106',10,log)
    elsif fix_number(user,mob,'019','0109',10,log)
    elsif fix_number(user,mob,'0151','0101',11,log)
    # Etisalat :
    elsif fix_number(user,mob,'011','0111',10,log)
    elsif fix_number(user,mob,'014','0114',10,log)
    elsif fix_number(user,mob,'0152','0112',11,log)
    else
      invalids << user.id
    end
  end
  #send report email
  log << "ID's of users with unchanged mobile numbers : \n #{invalids.inspect}"
  FixedMobilesReportMailer.report_email(log).deliver
end
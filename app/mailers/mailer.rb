# -*- coding: utf-8 -*-
class Mailer < ActionMailer::Base
  include Resque::Mailer
  layout 'email'
  default :from => "جمعية رسالة <no-reply@resala.org>"
  
  def feedback_email(feedback_title,feedback_body,feedback_email)
    @title = feedback_title
    @msg = feedback_body
    @email = feedback_email
    mail(:to => FEEDBACK_EMAIL,
         :subject => "[Resala Feedback] #{@title}",
         :reply_to => @email||nil)
  end
  
  def bulk_email(email_subject,email_body,email_media,recipients,newsletter_version = false)
    @email_body = email_body
    @email_media = email_media
    @newsletter_version = newsletter_version
    @email_media.each_with_index do |m,index|
      attachments.inline["#{index}.jpg"] = File.read(m)
    end
    mail(:to => SENDER_EMAIL,
         :subject => email_subject,
         :bcc => recipients)
  end
  
  def activities_authority_requested(volunteer)
    @volunteer = volunteer
    mail(:to => volunteer.email,
         :subject => I18n.t("activities_authority_status.requested") )
  end
  
  def activities_authority_status_updated(volunteer_id)
    @volunteer = Volunteer.find(volunteer_id)
    mail(:to => @volunteer.email,
         :subject => I18n.t("activities_authority_status.status_name_#{@volunteer.activities_authority_status}") )
  end
  
  def volunteer_response(volunteer_id,activity_request_id)
    @volunteer = Volunteer.find(volunteer_id)
    @activity_request = ActivitiesRequest.find(activity_request_id)
    if @activity_request.status == ActivitiesAuthorityStatus.accepted
      mail(:to => @volunteer.email,
           :subject => I18n.t("activity_status.volunteer_accepted") )
    else
      mail(:to => @volunteer.email,
           :subject => I18n.t("activity_status.volunteer_rejected") )
    end
  end
  
  def volunteer_joined_notification(volunteer_id,activity_id)
    @volunteer = Volunteer.find(volunteer_id)
    @activity = Activity.find(activity_id)
    mail(:to => @volunteer.email,
         :subject => I18n.t("activity_status.volunteer_joined") )
  end
  
  def activity_published(activity_id,url)
    I18n.locale = 'ar'
    @activity = Activity.find(activity_id)
    @owner = @activity.user
    @url = url
    mail(:to => @owner.email,
         :subject => I18n.t("activity_status.status_2") )
  end
  
  def upcoming_activities_volunteer_notification(volunteer_id, activities_ids)
    @activities = Activity.where(:id => activities_ids)
    @volunteer = Volunteer.find(volunteer_id)
    mail(:to => @volunteer.email,
         :subject => I18n.t("messages.upcoming_activities") )
  end
  
  def activity_start_reminder(activity_id, volunteer_id)
    @activity = Activity.find(activity_id)
    @volunteer = Volunteer.find(volunteer_id)
    mail(:to => @volunteer.email,
         :subject => I18n.t("messages.activity_reminder") )
  end
  
  def activity_published_volunteers_notification(activity_id,recipients,url)
    @activity = Activity.find(activity_id)
    @url = url
    mail(:to => SENDER_EMAIL,
         :bcc => recipients,
         :subject => I18n.t("messages.activity_published_notify") )
  end
  
  def activity_rejected(activity_id,url)
    @activity = Activity.find(activity_id)
    @owner = @activity.user
    @url = url
    mail(:to => @owner.email,
         :subject => I18n.t("activity_status.status_3") )
  end
  
  def activity_closed_notify_owner(activity_id,url)
    @activity = Activity.find(activity_id)
    @url = url
    mail(:to => @activity.user.email,
         :subject => I18n.t("activity_status.status_#{@activity.status}") )
  end
  
  def activity_cancelled_notify_owner(activity_id,url)
    @activity = Activity.find(activity_id)
    @url = url
    mail(:to => @activity.user.email,
         :subject => I18n.t("activity_status.status_#{@activity.status}"))
  end
  
  def activity_closed_notify_volunteers(activity_id,url)
    @activity = Activity.find(activity_id)
    @url = url
    mail(:to => SENDER_EMAIL,
         :bcc => @activity.accepted_volunteers.collect(&:email).join(","),
         :subject => I18n.t("activity_status.status_#{@activity.status}") )
  end
  
  def activity_closing_rejected_owner_notification(activity_id,url,previous_state)
    @activity = Activity.find(activity_id)
    @url = url
    @previous_state = previous_state
    subject = (previous_state == ActivitiesStatus.request_close) ? I18n.t("activity_status.status_8"):I18n.t("activity_status.status_9")
    mail(:to => @activity.user.email,
         :subject => subject )
  end
  
  def facebook_comment_notification_email(activity_id, comment_text, commentor_uid, commentor_name = nil, others = nil)
    @activity = Activity.find(activity_id)
    @comment_text = comment_text
    recipients = @activity.volunteers.select(&:email).collect(&:email)
    recipients += User.where(:uid => others).collect(&:email).compact  if ! others.blank? 
    owner_email = @activity.user.email
    recipients << owner_email if !owner_email.blank?
    recipients.uniq!
    
    if(commentor = User.find_by_uid(commentor_uid))
      @commentor = commentor
      recipients.delete(commentor.email) #don't notify the comment author about his own comment
    else
      @commentor_name = commentor_name 
    end
    mail(:to => SENDER_EMAIL,
         :bcc=> recipients,
         :subject => I18n.t("messages.new_facebook_comment_added"))
  end
  
  def activity_authority_request_admins_notification(volunteer_id)
    @volunteer = Volunteer.find(volunteer_id)
    admins_emails = Admin.select([:email,:uid]).collect(&:email).compact
    mail(:to => SENDER_EMAIL,
         :bcc=> admins_emails,
         :subject => I18n.t("messages.new_activity_authority_request"))
  end
  
  def volunteers_report(report_file_path, email)
    attachments['volunteers.zip'] = File.read(report_file_path);
    mail(:to => email,
         :subject => I18n.t("messages.volunteers_report"))
  end  
end

class Subscribe < ActionMailer::Base
  layout 'email'
  default :from => "no-reply@resala.org"
  
  def subscribe_confirmation(subscriber)
    @subscriber = subscriber
    mail(:to => @subscriber.email,
         :subject => I18n.t("messages.subscribe_confirmation"))
  end
  
  def unsubscribe_confirmation(subscriber)
    @subscriber = subscriber
    mail(:to => @subscriber.email,
         :subject => I18n.t("messages.unsubscribe_confirmation"))
  end
  
end

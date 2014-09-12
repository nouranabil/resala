class NewsletterSubscribersController < ApplicationController
  def create
    @newsletter_subscriber = NewsletterSubscriber.find_or_initialize_by_email(params[:newsletter_subscriber][:email])
    @newsletter_subscriber.attributes = params[:newsletter_subscriber]
    
    @newsletter_subscriber.token = Time.now.to_i.to_s if @newsletter_subscriber && !@newsletter_subscriber.confirmed
    
    respond_to do |format|
      if @newsletter_subscriber.save
        Subscribe.subscribe_confirmation(@newsletter_subscriber).deliver
        format.html do 
          set_cookie("notice", t('messages.added_to_newsletter_subscribers'))
          redirect_to(params[:redirect_to_url] ? params[:redirect_to_url] : root_path)
        end
        format.js { render :status => :ok }
      else
        format.html do 
          set_cookie("alert", @newsletter_subscriber.errors.full_messages.join(" #{t("messages.and")} "))
          redirect_to(params[:redirect_to_url] ? params[:redirect_to_url] : root_path)
        end
        format.js { render :status => :ok }
      end
    end
  end
  
  def subscribe_confirmation
    @newsletter_subscriber = NewsletterSubscriber.find_by_email_and_token(params[:email], params[:token])
    if @newsletter_subscriber
      @newsletter_subscriber.confirmed = true
      @newsletter_subscriber.save
      set_cookie("notice", t("messages.subscribe_confirmed"))
    else
      subscriber = NewsletterSubscriber.find_by_email(params[:email])
      if subscriber && subscriber.confirmed 
        set_cookie("alert", t("messages.subscribe_confirmed_before"))
      else
        set_cookie("alert", t("messages.subscribe_not_confirmed"))
      end
    end
    redirect_to "/news"
  end
  
  def unsubscribe
    @newsletter_subscriber = NewsletterSubscriber.find_by_email(params[:email])
    @newsletter_subscriber.token = Time.now.to_i.to_s if @newsletter_subscriber
    
    respond_to do |format|
      if @newsletter_subscriber && @newsletter_subscriber.save
        Subscribe.unsubscribe_confirmation(@newsletter_subscriber).deliver
        format.html do 
          set_cookie("notice", t("messages.removed_from_newsletter_subscribers"))
        end
        format.js { render :status => :ok }
      else
        format.html do 
          set_cookie("alert", t("messages.unsubscribe_confirmed_before"))
        end
        format.js { render :status => :ok }
      end
    end
    
    
    redirect_to(request.env["HTTP_REFERER"] || root_path)
  end
  
  
  def unsubscribe_confirmation
    @newsletter_subscriber = NewsletterSubscriber.find_by_email_and_token(params[:email], params[:token])
    if @newsletter_subscriber
      @newsletter_subscriber.destroy
      set_cookie("notice", t("messages.unsubscribe_confirmed"))
    else
      set_cookie("alert", t("messages.unsubscribe_confirmed_before"))
    end
    redirect_to "/news"
  end
end
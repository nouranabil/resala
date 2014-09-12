class Admin::NewsletterSubscribersController < Admin::AdminController
  def index
    if params[:confirmed] == "1"
      @newsletter_subscribers = NewsletterSubscriber.confirmed
    elsif params[:confirmed] == "2"
      @newsletter_subscribers = NewsletterSubscriber.unconfirmed
    else
      @newsletter_subscribers = NewsletterSubscriber
    end
    @newsletter_subscribers = @newsletter_subscribers.order('created_at desc').paginate(:page => params[:page], :per_page=>NewsletterSubscriber.per_page).all
  end
  
  def destroy
    newsletter_subscriber = NewsletterSubscriber.find(params[:id])
    newsletter_subscriber.destroy
    params[:page] ||= 1
    redirect_to admin_newsletter_subscribers_path(:page=>params[:page]), :notice => t("messages.deleted")
  end
end
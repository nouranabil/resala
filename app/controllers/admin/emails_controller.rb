class Admin::EmailsController < Admin::AdminController
  before_filter :prepare_lists, :except=> :preview

  def new
    @email = BulkEmail.new
  end
  
  def create
    @email = BulkEmail.new(params[:bulk_email])
    @email.branches = params[:branches]
    @email.activity_categories = params[:activity_categories]
    recipients = []
    #load category recipients if category
    ActivityCategory.where(:id => params[:activity_categories]).each{ |ac| recipients += ac.volunteers.select('email').collect(&:email) } unless params[:activity_categories].blank?
    #narrow down  using branch recipients if branch
    params[:branches].delete("") if params[:branches] && params[:branches].is_a?(Array) 
    unless params[:branches].blank?
      branch_recipients = []
      Branch.where(:id => params[:branches]).each{ |br| branch_recipients += br.volunteers.select('email').collect(&:email) }
      recipients &= branch_recipients.uniq 
    end
    
    #load admins if admins
    recipients += Admin.select('email').collect(&:email).uniq.compact unless params[:bulk_email].blank? || params[:bulk_email][:send_to_admins].blank? || params[:bulk_email][:send_to_admins] == '0'
    
    unless params[:email_media].blank?
      params[:email_media].each_with_index do |m,index|
        name =  m['datafile'] ? m['datafile'].original_filename : "#{index}"
        directory = "public/uploads"
        path = File.join(directory, name)
        File.open(path, "wb") { |f| f.write(m['datafile'].read) }
        @email.media << path
      end
    end
    
    #send the email
    @email.recipients = recipients.uniq
    @email.save
    
    # Handle newsletter recipients
    unless params[:bulk_email].blank? || params[:bulk_email][:newsletter].blank? || params[:bulk_email][:newsletter] == '0'
      #load newsletter subscribers if newsletter subscribers
      nl_recipients = NewsletterSubscriber.confirmed.collect(&:email)
      @email.recipients = (nl_recipients - @email.recipients).uniq
      @email.newsletter_version = true
      @email.save
    end
    
    flash[:notice] = t('messages.email_sent')
    
    render :action=> :new
  end
  
  def preview
    @email = BulkEmail.new(params[:bulk_email])
    render :layout=> false
  end
  
  def email_counts
    #initialize
    recipients = []; @recipients_count = 0; @ag_names = []; @br_names=[]
    #load category recipients if category
    ActivityCategory.where(:id => params[:activity_categories]).each do |ac|
      recipients += ac.volunteers.select('email').collect(&:email)
      @ag_names <<  ac.name
    end unless params[:activity_categories].blank?
    #narrow down  using branch recipients if branch
    params[:branches].delete("") if params[:branches] && params[:branches].is_a?(Array) 
    unless params[:branches].blank?
      branch_recipients = []
      Branch.where(:id => params[:branches]).each do |br| 
        branch_recipients += br.volunteers.select('email').collect(&:email)
        @br_names <<  br.name 
      end
      recipients &= branch_recipients.uniq 
    end
    #load newsletter subscribers if newsletter subscribers if newsletter subscribers
    recipients += NewsletterSubscriber.confirmed.collect(&:email) unless params[:bulk_email].blank? || params[:bulk_email][:newsletter].blank? || params[:bulk_email][:newsletter] == '0'
    #load admins if admins
    recipients += Admin.select('email').collect(&:email) unless params[:bulk_email].blank? || params[:bulk_email][:send_to_admins].blank? || params[:bulk_email][:send_to_admins] == '0'
    recipients.uniq!
    @recipients_count = recipients.length
  end
  
  #######
  private
  #######
  
  def prepare_lists
    @activity_categories = ActivityCategory.all
    @branches = Branch.branches_list
  end
end
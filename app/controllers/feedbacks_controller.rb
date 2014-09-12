class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end
  
  def create
    @feedback = Feedback.new(params[:feedback])
    
    if @feedback.save
      set_cookie("notice", t("messages.sent"))
      redirect_to(root_path)
    else
      render :action => "new"
    end
  end
end

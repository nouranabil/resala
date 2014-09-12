class QuestionsController < ApplicationController

  def index
    if params[:activity_category_id]
      @activity_category = ActivityCategory.find(params[:activity_category_id])
      @questions = @activity_category.questions.paginate(:page => params[:page], :per_page=>Question.per_page)
    else
      @questions = Question.paginate(:page => params[:page], :per_page=>Question.per_page)
    end
  end
  
end

class Admin::QuestionsController < Admin::AdminController
  def index
    @questions = Question.paginate(:page => params[:page], :per_page=>Question.per_page)
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(params[:question])
    
    if @question.save
      @question.move_to(params[:question][:position].to_i) if params[:question] && params[:question][:position]
      redirect_to(admin_questions_path, :notice => t("messages.saved", :name => t("question.question")) )
    else
      render :action => "new"
    end
  end
  
  def edit
    @question = Question.find(params[:id])
  end
  
  def update
    @question = Question.find(params[:id])
    @question.move_to(params[:question][:position].to_i) if params[:question] && params[:question][:position]

    if @question.update_attributes(params[:question])
      redirect_to(admin_questions_path(:page=>params[:page].blank? ? 1 : params[:page]) ,:notice => t("messages.saved", :name => t("question.question")))
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to admin_questions_path, :notice => t("messages.deleted")
  end
  
end

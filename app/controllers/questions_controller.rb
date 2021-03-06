class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    if current_user != nil
      @question = Question.new(question_params)
      @question.user_id = current_user.id
      if @question.save
        respond_to do |format|
          format.html do
            flash[:notice] = "Question added!"
            redirect_to user_path(current_user)
          end
          format.js { flash.now[:notice] = "Question added!" }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Question not added."
            render :new
          end
          format.js do
            render 'layouts/error'
          end
        end
      end
    end
  end

  def update
    @question = Question.find(params[:id])
    if current_user == @question.user
      @question.best_response = Response.find(params[:question][:best_response_id].to_i)
      @question.save
    end
    redirect_to question_path(@question)
  end

  def destroy
    @question = Question.find(params[:id])
    if @question.user == current_user
      @question.destroy
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
      end
    end
  end

private
  def question_params
    params.require(:question).permit(:title, :body)
  end

end

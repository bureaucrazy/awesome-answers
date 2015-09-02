class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  PER_PAGE = 10

  # The before action takes in a required first arg which ref a method that
  # will be exec before any action. You can give it a 2nd arg, which is a
  # hash. Possible keys are: :only and :except if you want to restrict
  # method to specific actions.
  # only: - whitelist
  # except: - blacklist
  # before_action :find_question, except: [:index, :new, :create]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :lock]

  before_action :authorize!, only: [:edit, :update, :destroy]

  # the new action is the one that is used by convention in Rails to display
  # a form to create the reocrd (in this case question record)

  def new
    # We instantiate an instance var of the obj we'd like to create
    # in order to use the 'form_for' helper method in Rails to easily generate
    # a form that submits to the create action
    @question = Question.new(title: "hello")
  end

  def create
    # question_params => {title: "Abc", body: "xyz"}
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      # flash[:notice] = "Question created!"
      # passing :notice / :alert only works for redirect
      redirect_to question_path(@question), notice: "Question created!"
    else
      flash[:alert] = "See errors below"
      render :new
    end
  end

  # GET /questions/:id (e.g. /questions/1)
  # this is used to show a page with question information
  def show
    # Instance variable defined in before_action
    # @question = Question.find params[:id]
    @answer = Answer.new

    @like = @question.likes.find_by_user_id(current_user.id) if user_signed_in?
    @favourite = @question.favourites.find_by_user_id(current_user.id) if user_signed_in?
  end

  # GET /questions
  # this is used to show a page with listing of all the questions in our DB
  def index
    if params[:search]
      # Using .order(params[:order]) is prone to SQL injection. Needs improvement.
      @questions = Question.search(params[:search]).order(params[:order]).page(params[:page]).per(PER_PAGE)
    else
      # @questions = Question.all.order(:id)
      # Code below uses Kaminari gem to replace code above
      @questions = Question.order(params[:order]).page(params[:page]).per(PER_PAGE)
    end
  end

  # GET /questions/:id/edit (e.g. /questions/123/edit)
  # this is used to show a form to edit and submit to update a question in the db
  def edit
    # Instance variable defined in before_action
    # @question = Question.find params[:id]

    # redirect_to root_path, alert: "Access denied" unless can? :edit, @question
  end

  # PATCH /questions/:id (e.g. /questions/123)
  # this is used to handle the submission of the question form from the edit page
  # when user is updating the information on a question
  def update
    # Instance variable defined in before_action
    # @question = Question.find params[:id]
    # if updating the question is successful
    if @question.update question_params
      # redirecting to the question show page
      redirect_to question_path(@question)
    else
      # rendering the edit form so the user can see the errors
      render :edit
    end
  end

  # DELETE /questions/:id (e.g. /questions/123)
  # this is used to delete a question from the database
  def destroy
    # Instance variable defined in before_action
    # @question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path
  end

  def lock
    # this toggles the value of locked between true and false
    @question.locked = !@question.locked
    @question.save
    redirect_to question_path(@question)
  end

  private

  def find_question
    @question = Question.find params[:id]
  end

  def authorize!
    redirect_to root_path, alert: "Access denied" unless can? :manage, @question
  end

  def question_params
    # params[:question] => {title: "Abc", body: "xyz"}
    # params.require ensures that the params hash has a key :question and
    # fetches all the attributes from that has.
    # The .permit only allows the parameters given to be mass-assigned.

    # this is using the strong paramters feature in Rails to only allow
    # the title and body to be updated in the database

    params.require(:question).permit([:title, :body, :locked, :category_id])
  end

end

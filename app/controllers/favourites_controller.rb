class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def create
    favourite = Favourite.new
    favourite = Favourite.new(question: @question, user: current_user)

    if favourite.save
      redirect_to @question, notice: "Added to favourite!"
    else
      redirect_to @question, alert: "Cannot favourite!"
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    if can? :destroy, favourite
      favourite.destroy
      redirect_to @question, notice: "Removed from favourite!"
    else
      redirect_to root_path, alert: "Access denied"
    end
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end
end

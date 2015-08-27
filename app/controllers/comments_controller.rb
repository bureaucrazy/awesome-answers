class CommentsController < ApplicationController
  def create
    @comment = Comment.new comment_params
    @answer  = Answer.find params[:answer_id]
    @comment.answer = @answer
    @comment.save

    # The dom_id is created here for use in the show.html.erb page
    # so we can navigate to a specific element on the page.
    answer_anchor = ActionController::Base.helpers.dom_id(@answer)
    redirect_to question_path(@answer.question, anchor: answer_anchor), notice: "comment created!"
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

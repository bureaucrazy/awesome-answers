class SubscribeController < ApplicationController
  def index
    @name = params[:name]
    @email = params[:email]
  end

  def create
    @name = params[:name]
    @email = params[:email]
    # render :thanks
  end

end

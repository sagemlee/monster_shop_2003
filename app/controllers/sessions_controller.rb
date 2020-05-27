class SessionsController < ApplicationController

  def new  
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}! You are now logged in."
      redirect_to '/'
    else
      flash[:error] = "Sorry, youre not one of us."
      render :new
    end
  end
end
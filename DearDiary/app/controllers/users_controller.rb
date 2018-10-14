require 'pry'
class UsersController < ApplicationController

  get '/signup' do
      if !Helpers.logged_in?(session)
        erb :'/users/signup'
      else
        redirect '/entries'
      end
    end

    post '/signup' do
      #use quote instead of symbols for params below?
      if Helpers.valid_params?(params[:username]) #can only send in one argument, but has secure pw already checks for pw
          user = User.create(:username => params[:username], :password => params[:password])
          session[:user_id] = user.id
          redirect "/entries"
        else
         	 redirect "/signup"
        end
    end


    get "/signin" do
      if Helpers.logged_in?(session)
        redirect '/entries'
      else
        erb :'/users/signin'
      end
    end

    post "/signin" do
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/entries"
      else
          redirect "/signup"
      end
    end

    post "/signout" do
        session.clear
        redirect "/signin"
    end


end

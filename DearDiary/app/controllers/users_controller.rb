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
      if Helpers.valid_params?(params[:username], params[:password])
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

    get "/signout" do
      if Helpers.logged_in?(session)
        erb :'users/signout'
      else
        redirect "/login"
      end
    end

    post "/signout" do
        session.clear
        redirect "/signin"
    end


end

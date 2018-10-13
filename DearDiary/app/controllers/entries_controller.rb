require 'date'

class EntriesController < ApplicationController

  get '/entries' do
    if Helpers.logged_in?(session)
      #make sure calling .entries like below works
      @entries = Helpers.current_user(session).entries
      erb :'entries/entries'
    else
      redirect '/signin'
    end
  end

  get '/entries/new' do
    if Helpers.logged_in?(session)
      erb :'tweets/new'
    else
      redirect '/signin'
    end
  end

  post '/entries' do
    if Helpers.valid_params?(params["content"])
      @entry = Entry.create
      @entry.date = Date.today.strftime("%A")
      @entry.content = params["content"]
      @entry.save
      @user = Helpers.current_user(session)
      @user.entries << @entry
      @user.save
      @entries = @user.entries
      erb :'entries/entries'
    else
      redirect '/entries/new'
    end
  end

  get '/entries/:id' do
    @entry = Entry.find_by_id(params[:id]) #define here so don't need to find_by_id twice
    @user = User.find_by_id(@entry.user_id)
    if Helper.logged_in?(session) && Helpers.current_user(session).id == @user.id
      erb :'entries/show_entry'
    else
      redirect '/signin'
    end
  end

  get '/entries/:id/edit' do
    @entry = Entry.find_by_id(params[:id])
    if !Helpers.logged_in?(session)
      redirect '/signin'
    elsif Helpers.current_user(session).entries.include?(@entry)
      erb :'/entries/edit'
    else
      redirect '/entries'
    end
  end

  patch '/entries/:id' do
    @entry = Entry.find_by_id(params[:id])
    if Helpers.valid_params?(params["content"])
      @entry.content = params["content"]
      @entry.save
      @user = User.find_by_id(@entry.user_id)
      erb :'entries/show_entry'
    else
      redirect "/entries/#{params[:id]}/edit"
  end

  get '/entries/:id/delete' do
    @entry = Entry.find_by_id(params[:id])
    if !Helpers.logged_in?(session)
      redirect '/signin'
    elsif Helpers.current_user(session).entries.include?(@entry)
      erb :'entries/delete'
    else
      redirect '/entries' #if redirect to signin but signed in won't let them
    end
  end

  delete '/entries/:id/delete' do
    #won't hit if don't click button
    @entry = Entry.find_by_id(params[:id])
    if !Helpers.logged_in?(session)
      redirect '/signin'
    elsif Helpers.current_user(session).entries.include?(@entry)
      @entry.destroy
      redirect '/entries'
    else
      redirect '/entries'
    end
  end

end

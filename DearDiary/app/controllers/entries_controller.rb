
class EntriesController < ApplicationController

  get '/entries' do
    if Helpers.logged_in?(session)
      @entries = Helpers.current_user(session).entries
      erb :'entries/entries'
    else
      redirect '/signin'
    end
  end

  get '/entries/new' do
    if Helpers.logged_in?(session)
      erb :'entries/new'
    else
      redirect '/signin'
    end
  end

  post '/entries' do
    if Helpers.valid_params?(params["content"])
      @entry = Entry.create
      date_today = DateTime.now
      @entry.date = date_today.strftime("%A, %B %d, %Y")
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
    if Helpers.logged_in?(session) && Helpers.current_user(session).id == @user.id
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
    if Helpers.valid_params?(params["content"]) && Helpers.current_user(session).entries.include?(@entry)
      @entry.content = params["content"]
      @entry.save
      @user = User.find_by_id(@entry.user_id)
      redirect "/entries/#{params[:id]}"
    else
      redirect "/entries/#{params[:id]}/edit"
    end
  end


  delete '/entries/:id/delete' do
    #got rid of get delete so can just have button, no need for seperate page
    #won't hit if don't click button
    @entry = Entry.find_by_id(params[:id])
    if !Helpers.logged_in?(session)
      redirect '/signin'
    elsif Helpers.current_user(session).entries.include?(@entry)
      @entry.destroy
      redirect '/entries'
    else
      redirect '/entries' #if redirect to sign in but already signed in, wont let them
    end
  end

end

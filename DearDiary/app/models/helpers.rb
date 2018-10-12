class Helpers < ActiveRecord::Base
  validates_presence_of :username, :password

  def self.current_user(session)
      User.find(session[:user_id])
  end

  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.valid_params?(params)
    if !params.empty?
      true
    end
  end

end

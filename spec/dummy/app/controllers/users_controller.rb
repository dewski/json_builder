class UsersController < ApplicationController
  def index
    require 'ostruct'
    @users = User.old
  end
end

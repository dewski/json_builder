class UsersController < ApplicationController
  def index
    require 'ostruct'
    @user = OpenStruct.new(:name => 'Garrett Bjerkhoel')
  end
end

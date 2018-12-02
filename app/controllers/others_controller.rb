class OthersController < ApplicationController
  before_action :authenticate_user!, only: [:help]

  def help
  end

  def disclaimer
  end

  def welcome
  end
end

class OthersController < ApplicationController
  before_action :authenticate_user!, only: [:help]

  def help
  end

  def disclaimer
  end

  def welcome
    redirect_to user_attendances_summary_path(current_user.id) if signed_in?
  end
end

class UsersController < ApplicationController
  def show
    @user_name = current_user.user_name
    @work_start_time = current_user.work_start_time
    @work_end_time = current_user.work_end_time
    @rest_start_time = current_user.rest_start_time
    @rest_end_time = current_user.rest_end_time
  end
end

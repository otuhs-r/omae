class UsersController < ApplicationController
  include ApplicationHelper

  def dashboard
    working_sec = current_user.working_seconds
    extra_working_sec = current_user.extra_working_seconds
    @sum_working_hours = convert_to_hh_mm_from_sec(working_sec)
    @sum_extra_working_hours = convert_to_hh_mm_from_sec(extra_working_sec)
    @extra_working_rate = working_sec != 0 ? ((extra_working_sec / working_sec) * 100).to_i : 0
  end

  def show
    @user_name = current_user.user_name
    @email = current_user.email
    @work_start_time = current_user.work_start_time
    @work_end_time = current_user.work_end_time
    @rest_start_time = current_user.rest_start_time
    @rest_end_time = current_user.rest_end_time
  end
end

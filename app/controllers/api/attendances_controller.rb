class Api::AttendancesController < Api::BaseController
  def create
    @all_working_seconds = current_user.working_seconds(@start_date, @end_date)
    @all_extra_working_seconds = current_user.extra_working_seconds(@start_date, @end_date)
    @average_extra_working_seconds = @all_extra_working_seconds / current_user.attendances.where(date: @start_date..@end_date).count
    @extra_working_rate = @all_working_seconds.zero? ? 0 : ((@all_extra_working_seconds / @all_working_seconds) * 100).to_i
    respond_to do |format|
      format.js
    end
  end

  def by_day_of_week
    data = current_user.average_extra_working_hours_by_day_of_week(@start_date, @end_date)
    render json: [{ data: data }].chart_json
  end
end

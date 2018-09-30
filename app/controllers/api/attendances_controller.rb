class Api::AttendancesController < Api::BaseController
  def create
    @dashboard = Dashboard.new(current_user, @start_date, @end_date)
    respond_to do |format|
      format.js
    end
  end

  def by_day_of_week
    data = current_user.average_extra_working_hours_by_day_of_week(@start_date, @end_date)
    render json: [{ data: data }].chart_json
  end
end

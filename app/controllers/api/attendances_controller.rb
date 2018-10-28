class Api::AttendancesController < Api::BaseController
  def create
    attendances = current_user.attendances.where(date: @start_date..@end_date)
    @dashboard = Dashboard.new(attendances)
    @days_all = (@end_date - @start_date).to_i + 1
    @all_seconds = @end_date.to_time - @start_date.to_time + 60
    respond_to do |format|
      format.js
    end
  end
end

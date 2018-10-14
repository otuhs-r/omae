class Api::AttendancesController < Api::BaseController
  def create
    attendances = current_user.attendances.where(date: @start_date..@end_date)
    @dashboard = Dashboard.new(attendances)
    respond_to do |format|
      format.js
    end
  end
end

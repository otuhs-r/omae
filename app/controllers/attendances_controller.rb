class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]

  def index
    @attendances = current_user.attendances
  end

  def new
    @attendance = current_user.attendances.build
  end

  def edit
  end

  def create
    @attendance = current_user.attendances.build(attendance_params)

    if @attendance.save
      redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendance.update(attendance_params)
      redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attendance_params
    params.require(:attendance).permit(:clock_in_time, :clock_out_time, :date)
  end
end
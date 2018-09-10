class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]
  include ApplicationHelper

  def dashboard
    now = Time.current
    start_date = now.beginning_of_month
    end_date = now
    @all_working_seconds = current_user.working_seconds(start_date, end_date)
    @all_extra_working_seconds = current_user.extra_working_seconds(start_date, end_date)
    @average_extra_working_seconds = @all_extra_working_seconds / current_user.attendances.where(date: start_date..end_date).count
    @extra_working_rate = @all_working_seconds.zero? ? 0 : ((@all_extra_working_seconds / @all_working_seconds) * 100).to_i
  end

  def clock_in_just_now
    attendance_params = { date: Time.zone.now.to_date, clock_in_time: Time.zone.now, clock_out_time: current_user.work_end_time }
    attendance = current_user.attendances.build(attendance_params)

    flash_message = if attendance.save
                      { notice: 'Attendance was successfully created.' }
                    else
                      { alert: 'Attendance has been already recorded today.' }
                    end
    redirect_to user_attendances_path(current_user.id), flash_message
  end

  def clock_out_just_now
    attendance = current_user.attendances.find { |a| a.date == Time.zone.now.to_date }
    flash_message = if attendance
                      attendance_params = { clock_out_time: Time.zone.now }
                      if attendance.update(attendance_params)
                        { notice: 'Attendance was successfully updated.' }
                      else
                        { alert: 'Clock out time should be later than clock in time.' }
                      end
                    else
                      attendance_params = { date: Time.zone.now.to_date, clock_in_time: current_user.work_start_time, clock_out_time: Time.zone.now }
                      attendance = current_user.attendances.build(attendance_params)
                      if attendance.save
                        { notice: 'Attendance was successfully created.' }
                      else
                        { alert: 'Clock out time should be later than clock in time.' }
                      end
                    end
    redirect_to user_attendances_path(current_user.id), flash_message
  end

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

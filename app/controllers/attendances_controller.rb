class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]
  include ApplicationHelper

  def summary
    now = Time.current
    attendances = current_user.attendances.where(date: now.beginning_of_month..now)
    @dashboard = Dashboard.new(attendances)
    @days_all = (now.to_date - now.beginning_of_month.to_date).to_i + 1
    @all_seconds = now.to_time - now.beginning_of_month.to_time + 60
  end

  def clock_in_just_now
    flash_message = if current_user.attendances.find { |a| a.date == Time.zone.now.to_date }
                      { alert: '本日の勤怠情報はすでに登録されています' }
                    else
                      attendance_params = { date: Time.zone.now.to_date, clock_in_time: Time.zone.now, clock_out_time: current_user.work_end_time }
                      attendance = current_user.attendances.build(attendance_params)
                      if attendance.save
                        { notice: '勤怠情報を登録しました' }
                      else
                        { alert: '出勤時刻は就業時刻より前である必要があります' }
                      end
                    end
    redirect_to user_attendances_path(current_user.id), flash_message
  end

  def clock_out_just_now
    attendance = current_user.attendances.find { |a| a.date == Time.zone.now.to_date }
    flash_message = if attendance
                      attendance_params = { clock_out_time: Time.zone.now }
                      if attendance.update(attendance_params)
                        { notice: '勤怠情報を更新しました' }
                      else
                        { alert: '退勤時刻は始業時刻より後である必要があります' }
                      end
                    else
                      attendance_params =
                        { date: Time.zone.now.to_date, clock_in_time: current_user.work_start_time, clock_out_time: Time.zone.now }
                      attendance = current_user.attendances.build(attendance_params)
                      if attendance.save
                        { notice: '勤怠情報を登録しました' }
                      else
                        { alert: '退勤時刻は始業時刻より後である必要があります' }
                      end
                    end
    redirect_to user_attendances_path(current_user.id), flash_message
  end

  def index
    @attendances = current_user.attendances
  end

  def weekly
    @dashboards = []
    current_user.attendances.group_by_week(&:date).each do |_key, value|
      @dashboards << Dashboard.new(value)
    end
  end

  def monthly
    @dashboards = []
    current_user.attendances.group_by_month(&:date).each do |_key, value|
      @dashboards << Dashboard.new(value)
    end
  end

  def new
    @attendance = current_user.attendances.build
  end

  def edit
  end

  def create
    @attendance = current_user.attendances.build(attendance_params)

    if @attendance.save
      redirect_to user_attendances_path(current_user.id), notice: '勤怠情報を登録しました'
    else
      render :new
    end
  end

  def update
    if @attendance.update(attendance_params)
      redirect_to user_attendances_path(current_user.id), notice: '勤怠情報を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to user_attendances_path(current_user.id), notice: '勤怠情報を削除しました'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attendance_params
    params.require(:attendance).permit(:clock_in_time, :clock_out_time, :date, :division)
  end
end

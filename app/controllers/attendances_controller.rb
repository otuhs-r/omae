class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = current_user.attendances
  end

  # GET /attendances/new
  def new
    @attendance = current_user.attendances.build
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = current_user.attendances.build(attendance_params)

      if @attendance.save
        redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully created.'
      else
        render :new
      end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
      if @attendance.update(attendance_params)
        redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully updated.'
      else
        render :edit
      end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      redirect_to user_attendances_path(current_user.id), notice: 'Attendance was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:clock_in_time, :clock_out_time, :user_id)
    end
end

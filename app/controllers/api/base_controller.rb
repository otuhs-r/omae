class Api::BaseController < ApplicationController
  before_action :format_dates

  private

  def format_dates
    @start_date = if params[:start_date].nil? || params[:start_date].empty?
                    Time.current.beginning_of_month
                  else
                    params[:start_date].to_datetime.midnight
                  end
    @end_date = if params[:end_date].nil? || params[:end_date].empty?
                  Time.current.at_end_of_day
                else
                  params[:end_date].to_datetime.at_end_of_day
                end
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
  end
end

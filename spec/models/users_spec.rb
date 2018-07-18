require 'rails_helper'

describe User do
  before do
    @user = build(:user)
  end

  subject { @user }

  it 'is valid with all of valid params.' do
    is_expected.to be_valid
  end

  it 'is invalid without a user name.' do
    @user.user_name = nil
    is_expected.to be_invalid
  end

  it 'is invalid without a email.' do
    @user.email = nil
    is_expected.to be_invalid
  end

  it 'is invalid without a work start time.' do
    @user.work_start_time = nil
    is_expected.to be_invalid
  end

  it 'is invalid without a work end time.' do
    @user.work_end_time = nil
    is_expected.to be_invalid
  end

  it 'is invalid without a rest start time.' do
    @user.rest_start_time = nil
    is_expected.to be_invalid
  end

  it 'is invalid without a rest end time.' do
    @user.rest_end_time = nil
    is_expected.to be_invalid
  end

  it 'is invalid with a too long user name.' do
    @user.user_name = 'a' * 11
    is_expected.to be_invalid
  end

  it 'is invalid with a work start time later than work end time.' do
    @user.work_start_time = Time.mktime(2018, 1, 1, 20, 0, 0)
    is_expected.to be_invalid
  end

  it 'is invalid with a rest start time later than rest end time.' do
    @user.rest_start_time = Time.mktime(2018, 1, 1, 15, 0, 0)
    is_expected.to be_invalid
  end

  it 'is invalid with a rest start time earlier than work start time.' do
    @user.rest_start_time = Time.mktime(2018, 1, 1, 5, 0, 0)
    is_expected.to be_invalid
  end

  it 'is invalid with a rest end time later than work end time.' do
    @user.rest_end_time = Time.mktime(2018, 1, 1, 20, 0, 0)
    is_expected.to be_invalid
  end
end

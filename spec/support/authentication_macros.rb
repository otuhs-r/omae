include Warden::Test::Helpers

module AuthenticationMacros
  def login
    let(:user) { build(:user) }
    before do
      login_as(user, scope: :user)
    end 
  end
end

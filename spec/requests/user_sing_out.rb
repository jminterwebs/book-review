require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "logs out the user" do
    delete destroy_user_session_path
    expect(response).to redirect_to(new_user_session_path)
  end
end

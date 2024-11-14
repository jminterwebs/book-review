require 'rails_helper'

RSpec.describe "UserRegistrations", type: :request do
  describe "POST /users" do
    it "creates a new user" do
      expect {
        post user_registration_path, params: { user: { email: 'testuser@example.com', password: 'password', password_confirmation: 'password' } }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path) # or the path you set after signup
    end
  end
end

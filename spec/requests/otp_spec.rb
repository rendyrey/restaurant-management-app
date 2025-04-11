# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Otps", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/otp/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/otp/create"
      expect(response).to have_http_status(:success)
    end
  end
end

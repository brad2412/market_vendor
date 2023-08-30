require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v0/markets/index"
      expect(response).to have_http_status(:success)
    end
  end

end

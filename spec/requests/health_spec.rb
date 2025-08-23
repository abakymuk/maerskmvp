require "rails_helper"

RSpec.describe "Health", type: :request do
  describe "GET /healthz" do
    it "returns http success with JSON response" do
      get "/healthz"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")

      json_response = JSON.parse(response.body)
      expect(json_response["ok"]).to be true
      expect(json_response["env"]).to eq("test")
    end
  end
end

require "rails_helper"

RSpec.describe "Market vendors delete end point" do
  describe "should delete a market vendor" do
    before(:each) do
      @market = create(:market)
      @vendor = create(:vendor)
      create(:market_vendor, market: @market, vendor: @vendor)

      expect(MarketVendor.count).to eq(1)

      market_vendor_params = { market_id: @market.id, vendor_id: @vendor.id }
      headers = { "CONTENT_TYPE" => "application/json" }

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)
    end

    it "should delete market vendor and have status code 204" do
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
      expect(MarketVendor.count).to eq(0)
    end

    it "should not populate market vendor and have a status code 200" do
      get "/api/v0/markets/#{@market.id}/vendors"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendors_data = data[:data]
      expect(vendors_data).to be_an(Array)
      expect(vendors_data.count).to eq(0)
    end
  end

  describe "sad path testing" do
    it "should have status code 404" do
      market = create(:market)
      false_id = 123123123123
      market_vendor_params = {
                                "market_id": market.id,
                                "vendor_id": false_id
                              }
      headers = { "CONTENT_TYPE" => "application/json" }
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)
      errors = data[:errors]

      expect(errors).to be_an(Array)
      expect(errors.first[:detail]).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{false_id} exists")
    end
  end
end

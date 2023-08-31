require "rails_helper"

RSpec.describe "MarketVendors API" do
  describe "Market vendor end point" do
    before(:each) do
      @market1 = create(:market)
      @vendor1 = create(:vendor)
      @market_vendor_params = { market_id: @market1.id, vendor_id: @vendor1.id }
      @headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_vendor: @market_vendor_params)
    end

    it "should create a market_vendor and have status 201" do
      expect(response).to be_successful
      expect(response.status).to eq(201)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:message)
      expect(data[:message]).to eq("Successfully added vendor to market")
    end

    it "should have list of market vendors" do
      get "/api/v0/markets/#{@market1.id}/vendors"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendors_data = data[:data]
      expect(vendors_data).to be_an(Array)
      expect(vendors_data.count).to eq(1)

      vendor = vendors_data.first
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
      expect(vendor[:id]).to eq(@vendor1.id.to_s)
    end
  end

  describe "sad path" do
    it "should have a 404 status" do
      false_id = 987654321
      vendor1 = create(:vendor)

      market_vendor_params = { market_id: false_id, vendor_id: vendor1.id }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      expect(errors.first[:detail]).to eq("Validation failed: Market must exist")
    end

    it "should have a 404 status error" do
      market1 = create(:market)
      false_id = 987654321

      market_vendor_params = { market_id: market1.id, vendor_id: false_id }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      expect(errors.first[:detail]).to eq("Validation failed: Vendor must exist")
    end

    it "should have a 400 status error" do
      market_vendor_params = { market: "", vendor: "" }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      error_message = "Validation failed: Market must exist, Vendor must exist"
      expect(errors.first[:detail]).to eq(error_message)
    end

    it "should have a 422 status error" do
      market1 = create(:market)
      vendor1 = create(:vendor)
      create(:market_vendor, market: market1, vendor: vendor1)

      market_vendor_params = { market_id: market1.id, vendor_id: vendor1.id }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      error_message = "Validation failed: Market vendor association between market with market_id=#{market1.id} and vendor_id=#{vendor1.id} already exists"
      expect(errors.first[:detail]).to eq(error_message)
    end
  end
end

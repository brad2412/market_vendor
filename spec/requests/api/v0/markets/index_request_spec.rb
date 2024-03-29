require "rails_helper"

RSpec.describe "Markets endpoints" do
  describe "User story: Get all Markets" do
    it "returns all markets and vendor count" do
      create_list(:market, 3)

      get "/api/v0/markets"

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:data)

      markets = data[:data]
      expect(markets).to be_an(Array)
      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)

        attributes = market[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:street)
        expect(attributes[:street]).to be_a(String)

        expect(attributes).to have_key(:city)
        expect(attributes[:city]).to be_a(String)

        expect(attributes).to have_key(:county)
        expect(attributes[:county]).to be_a(String)

        expect(attributes).to have_key(:state)
        expect(attributes[:state]).to be_a(String)

        expect(attributes).to have_key(:zip)
        expect(attributes[:zip]).to be_a(String)

        expect(attributes).to have_key(:lat)
        expect(attributes[:lat]).to be_a(String)

        expect(attributes).to have_key(:lon)
        expect(attributes[:lon]).to be_a(String)

        expect(attributes).to have_key(:vendor_count)
        expect(attributes[:vendor_count]).to be_an(Integer)
      end
    end
  end
end

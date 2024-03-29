require "rails_helper"

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    it "should show the count of vendors associated with markets" do
      market1 = create(:market)
      vendors = create_list(:vendor, 3)

      create(:market_vendor, market: market1, vendor: vendors[0])
      create(:market_vendor, market: market1, vendor: vendors[1])

      expect(market1.vendor_count).to eq(2)
    end
  end
end
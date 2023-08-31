require "rails_helper"

RSpec.describe MarketVendor, type: :model do
  describe "relationships" do
    it { should belong_to(:market) }
    it { should belong_to(:vendor) }
  end

  describe "validations" do
    it "#no_dublication" do
    market1 = create(:market)
    vendor1 = create(:vendor)
    market_vendor = create(:market_vendor, market: market1, vendor: vendor1)

    expect(market_vendor).to be_valid
    expect { create(:market_vendor, market: market1, vendor: vendor1) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
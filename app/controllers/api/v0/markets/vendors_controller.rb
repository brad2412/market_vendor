class Api::V0::Markets::VendorsController < ApplicationController

  def index
    @market = Market.find(params[:market_id])
    if @market
      render json: VendorSerializer.new(@market.vendors)
    else
      error_message = "Market not found"
      render json: ErrorSerializer.serialize(error_message), status: 404
    end
  end
end
class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    @market = Market.find(params[:id])
    if @market
      render json: MarketSerializer.new(@market)
    else
      error_message = "Market not found"
      render json: ErrorSerializer.serialize(error_message), status: 404
    end
  end
end

class Api::V0::MarketVendorsController < ApplicationController
  def create
    MarketVendor.create!(market_vendor_params)
    success_message
  rescue ActiveRecord::RecordInvalid => error
    fail_message(error, market_vendor_params)
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    if !market_vendor.nil?
      market_vendor.destroy
    else
      no_market_vendor(market_vendor_params)
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def success_message
    render json: { "message": 'Successfully added vendor to market' }, status: :created
  end

  def fail_message(error, params)
    if params.empty?
      render_invalid_response(error)
    elsif MarketVendor.find_by(params)
      already_exists(error)
    else
      render_not_found_response(error)
    end
  end

  def already_exists(error)
    render json: ErrorSerializer.serialize(error), status: :unprocessable_entity
  end

  def no_market_vendor(params)
    message = "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"
    render json: ErrorSerializer.serialize(message), status: :not_found
  end
end

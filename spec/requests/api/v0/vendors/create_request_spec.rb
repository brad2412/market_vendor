require "rails_helper"

RSpec.describe "Vendors create endpoint" do
  describe "Creating a Vendor" do
    it "creates a vendor and should have a status code 201" do
      vendor_params = {
                        "name": "Buzzy Bees",
                        "description": "local honey and wax products",
                        "contact_name": "Berly Couwer",
                        "contact_phone": "8389928383",
                        "credit_accepted": false
                      }

      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
  end

  describe "testing for sad path" do
    it "has a 400 error if attributes are not given" do
      vendor_params = { param: "param" }
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:errors)
      errors = data[:errors]
      expect(errors).to be_an(Array)

      all_errors_message = "Validation failed: Name can't be blank, Description can't be blank, Contact name can't be blank, Contact phone can't be blank, Credit accepted is reserved"
      expect(errors.first[:detail]).to eq(all_errors_message)
    end
  end
end
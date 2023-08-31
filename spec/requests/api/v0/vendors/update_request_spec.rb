require "rails_helper"

RSpec.describe "Vendors update endpoint" do
  describe "User Story: Update a Vendor" do
    it "should update a vendor" do
      vendor = create(:vendor)

      update_params = {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: update_params)
      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(created_vendor.contact_name).to eq(update_params[:contact_name])
      expect(created_vendor.credit_accepted).to eq(update_params[:credit_accepted])
    end

    it "should have a 404 error" do
      false_id = 123123123
      update_params = {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{false_id}", headers: headers, params: JSON.generate(vendor: update_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      expect(errors.first[:detail]).to eq("Couldn't find Vendor with 'id'=#{false_id}")
    end

    it "should have a 400 erro" do
      vendor = create(:vendor)

      update_params = {
                        "name": '',
                        "description": '',
                        "contact_name": '',
                        "contact_phone": '',
                        "credit_accepted": ''
                      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: update_params)

      expect(response).to_not be_successful
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
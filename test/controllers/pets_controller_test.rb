require 'test_helper'

class PetsControllerTest < ActionDispatch::IntegrationTest
  describe "index" do
    # These tests are a little verbose - yours do not need to be
    # this explicit.
    it "is a real working route" do
      get pets_path
      must_respond_with :success
    end

    it "returns json" do
      get pets_url
      response.header['Content-Type'].must_include 'json'
    end

    it "returns an Array" do
      get pets_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the pets" do
      get pets_url

      body = JSON.parse(response.body)
      body.length.must_equal Pet.count
    end

    it "returns pets with exactly the required fields" do
      keys = %w(age human id name)
      get pets_url
      body = JSON.parse(response.body)
      body.each do |pet|
        pet.keys.sort.must_equal keys
      end
    end
  end

  describe "show" do
    # This bit is up to you!
    it "can get a pet" do
      get pet_path(pets(:two).id)
      must_respond_with :success
    end

    it "returns a 404 for pets that are not found" do
      # Arrange
      pet = pets(:two)
      pet.destroy
      # Action
      get pet_path(pet.id)

      # Assert
      must_respond_with :not_found

    end
  end

  describe "create" do
    let(:pet_data) {
      {
        name: "Jack",
        age: 7,
        human: "Captain Barbossa"
      }
    }

    it "Creates a new pet" do

      proc {
        post pets_path, params: {pet: pet_data}
      }.must_change 'Pet.count', 1

      must_respond_with :success

      # assert_difference "Pet.count", 1 do
      #   post pets_url, params: { pet: pet_data }
      #   assert_response :success
      end

      it "returns bad request for bad params data" do
        # Arrage
        pet_data.delete(:name)
        # Act
        proc {
          post pets_path, params: {pet: pet_data}
        }.wont_change 'Pet.count'
        # Asserts
        must_respond_with :bad_request
          body = JSON.parse(response.body)
          body.must_be_kind_of Hash
          body.must_include "ok"
          body["ok"].must_equal false
          body.must_include "errors"
          body["errors"].must_include "name"

      end
    #
    #   body = JSON.parse(response.body)
    #   body.must_be_kind_of Hash
    #   body.must_include "id"
    #
    #   # Check that the ID matches
    #   Pet.find(body["id"]).name.must_equal pet_data[:name]
    # end
    #
    # it "Returns an error for an invalid pet" do
    #   bad_data = pet_data.clone()
    #   bad_data.delete(:name)
    #   assert_no_difference "Pet.count" do
    #     post pets_url, params: { pet: bad_data }
    #     assert_response :bad_request
    #   end
    #
    #   body = JSON.parse(response.body)
    #   body.must_be_kind_of Hash
    #   body.must_include "errors"
    #   body["errors"].must_include "name"
    # end
  end
end

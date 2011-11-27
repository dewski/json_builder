require 'spec_helper'

describe UsersController do
  before do
    @request.env["HTTP_ACCEPT"] = "application/json"
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end

require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	test "should GET index" do
		get :index

		assert_response :success
		assert_template "layouts/application"
	end

	test "should POST results" do 
		post :result, 
		location: "location",
		authtoken: "AAA",
		apptoken: "AAA",
		starttime: "1",
		stoptime: "2",
		users: "1"

		assert_equal 200, response.status
	end
end
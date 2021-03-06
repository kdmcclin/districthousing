require "test_helper"

class ResidencesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def residence
    @residence ||= residences :one
  end

  def test_new
    sign_in users(:one)
    get :new
    assert_response :success
  end

  def test_create
    sign_in users(:one)
    assert_difference('Residence.count') do
      post :create, residence: residence.attributes
    end

    assert_redirected_to edit_residence_path(assigns(:residence))
  end

  def test_update
    sign_in users(:one)
    session[:current_applicant_id] = 1
    put :update, id: residence, residence: residence.attributes
    assert_redirected_to applicant_path(applicants(:one))
  end

  def test_destroy
    sign_in users(:one)
    session[:current_applicant_id] = 1
    assert_difference('Residence.count', -1) do
      delete :destroy, id: residence
    end

    assert_redirected_to applicant_path(applicants(:one))
  end
end

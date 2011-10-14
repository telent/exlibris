require "minitest_helper"

class ShelfControllerTest < MiniTest::Rails::Controller
  setup do
    @shelf = shelves(:one)
  end

  it "must get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shelves)
  end

  it "must get new" do
    get :new
    assert_response :success
  end

  it "must create shelf" do
    assert_difference('Shelf.count') do
      post :create, shelf: @shelf.attributes
    end

    assert_redirected_to shelf_path(assigns(:shelf))
  end

  it "must show shelf" do
    get :show, id: @shelf.to_param
    assert_response :success
  end

  it "must get edit" do
    get :edit, id: @shelf.to_param
    assert_response :success
  end

  it "must update shelf" do
    put :update, id: @shelf.to_param, shelf: @shelf.attributes
    assert_redirected_to shelf_path(assigns(:shelf))
  end

  it "must destroy shelf" do
    assert_difference('Shelf.count', -1) do
      delete :destroy, id: @shelf.to_param
    end

    assert_redirected_to shelves_path
  end
end

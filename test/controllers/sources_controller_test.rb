require 'test_helper'

class SourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @source = sources(:one)
  end

  test "should get index" do
    get sources_url, as: :json
    assert_response :success
  end

  test "should create source" do
    assert_difference('Source.count') do
      post sources_url, params: { source: { category: @source.category, country: @source.country, description: @source.description, language: @source.language, name: @source.name, sort_bys: @source.sort_bys, url: @source.url, url_to_logo: @source.url_to_logo } }, as: :json
    end

    assert_response 201
  end

  test "should show source" do
    get source_url(@source), as: :json
    assert_response :success
  end

  test "should update source" do
    patch source_url(@source), params: { source: { category: @source.category, country: @source.country, description: @source.description, language: @source.language, name: @source.name, sort_bys: @source.sort_bys, url: @source.url, url_to_logo: @source.url_to_logo } }, as: :json
    assert_response 200
  end

  test "should destroy source" do
    assert_difference('Source.count', -1) do
      delete source_url(@source), as: :json
    end

    assert_response 204
  end
end

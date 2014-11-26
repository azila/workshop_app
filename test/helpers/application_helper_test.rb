require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def controller_name
    "Parkings"
  end

  test "should properly transform controller name" do
    assert "Parkings", name_helper
  end

end

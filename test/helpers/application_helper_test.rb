require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'flash_class returns alert-success for notice' do
    assert_equal 'alert-success', flash_class(:notice)
  end

  test 'flash_class returns alert-warning for alert' do
    assert_equal 'alert-warning', flash_class(:alert)
  end

  test 'flash_class returns alert-danger for error' do
    assert_equal 'alert-danger', flash_class(:error)
  end

  test 'flash_class returns alert-info for other messages' do
    assert_equal 'alert-info', flash_class(:info) # unhandled case
  end
end

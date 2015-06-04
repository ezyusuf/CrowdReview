require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  test "validates title uniqeuness" do
    orig = build(:nominal)
    copy = build(:nominal)

    assert  orig.save, "saved an article"
    refute  copy.save, "saved a duplicate"
  end

  test "validates abstract length" do
    inadequate = build(:boundary_case_one_short)
    refute  inadequate.save, "rejecting a nine word abstract"
  end
end

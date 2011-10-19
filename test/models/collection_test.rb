require "minitest_helper"

class CollectionTest < MiniTest::Rails::Model
  before do
    @owner=User.create(:name=>"hello")
    @collection=@owner.collections.create(:name=>"test")
  end

  it "has permissions" do
    user1=User.create(:name=>"user 1")
    user2=User.create(:name=>"user 2")
    @collection.permit(user1,:browse)
    assert @collection.permitted?(user1,:browse)
    refute @collection.permitted?(user2,:browse)
    refute @collection.permitted?(user1,:borrow)
    assert_equal [user1,@owner],  @collection.permitted_users(:browse)
  end

  it "removes a permission" do
    user1=User.create(:name=>"user 1")  
    @collection.permit(user1,:browse)
    @collection.permit(user1,:search)
    @collection.forbid(user1,:browse)
    refute @collection.permitted?(user1,:browse)
    assert @collection.permitted?(user1,:search)
  end
  it "removes all permission" do
    user1=User.create(:name=>"user 1")  
    @collection.permit(user1,:browse)
    @collection.permit(user1,:search)
    @collection.forbid(user1)
    refute @collection.permitted?(user1,:browse)
    refute @collection.permitted?(user1,:search)
  end
end

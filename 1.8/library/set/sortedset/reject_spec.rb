require File.dirname(__FILE__) + '/../../../spec_helper'
require 'set'

describe "SortedSet#reject!" do
  before(:each) do
    @set = SortedSet["one", "two", "three"]
  end
  
  ruby_bug "http://redmine.ruby-lang.org/issues/show/115", "1.8.7.7" do
    it "yields each Object in self in sorted order" do
      res = []
      @set.reject! { |x| res << x }
      res.should == ["one", "two", "three"].sort
    end
  end
  
  it "deletes every element from self for which the passed block returns true" do
    @set.reject! { |x| x.size == 3 }
    @set.size.should eql(1)
    
    @set.should_not include("one")
    @set.should_not include("two")
    @set.should include("three")
  end
  
  it "returns self when self was modified" do
    @set.reject! { |x| true }.should equal(@set)
  end

  it "returns nil when self was not modified" do
    @set.reject! { |x| false }.should be_nil
  end

  ruby_version_is "" ... "1.8.8" do
    it "raises a LocalJumpError when passed no block" do
      lambda { @set.reject! }.should raise_error(LocalJumpError)
    end
  end
  
  ruby_version_is "1.8.8" do
    it "returns an Enumerator when passed no block" do
      enum = @set.reject!
      enum.should be_kind_of(Enumerable::Enumerator)
      
      enum.each { |x| x.size == 3 }
      
      @set.should_not include("one")
      @set.should_not include("two")
      @set.should include("three")
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

# specs for __ENCODING__

describe "The __ENCODING__ pseudo-variable" do
  it "is an instance of Encoding" do
    __ENCODING__.should be_kind_of(Encoding)
  end

  it "equals US-ASCII" do
    __ENCODING__.should == Encoding::US_ASCII
  end

  it "equals the evaluated strings's one inside an eval" do
    eval("__ENCODING__".force_encoding("US-ASCII")).should == Encoding::US_ASCII
    eval("__ENCODING__".force_encoding("ASCII-8BIT")).should == Encoding::ASCII_8BIT
  end

  it "equals the specified encoding when a magic comment exists" do
    eval("# coding: ASCII-8BIT\n__ENCODING__".force_encoding("US-ASCII")).should == Encoding::ASCII_8BIT
    eval("# coding: US-ASCII\n__ENCODING__".force_encoding("ASCII-8BIT")).should == Encoding::US_ASCII
  end

  it "is not assignable" do
    lambda {
      eval("__ENCODING__ = nil")
    }.should raise_error(SyntaxError, /Can't assign to __ENCODING__/)
  end
end

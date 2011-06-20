require 'spec_helper'
require 'multiproc'

class Multiproc

  describe "new" do
    it "should instantiate" do
      lambda {
        Multiproc.new ['pwd']
      }.should_not raise_exception
    end

    it "should not allow non arrays" do
      lambda {
        Multiproc.new 1
      }.should raise_exception
    end

    it "should not allow non string element" do
      lambda {
        Multiproc.new [1]
      }.should raise_exception
    end

    it "should accept an array of strings" do
      lambda {
        Multiproc.new ['ls', 'pwd']
      }.should_not raise_exception
    end
  end

  describe "start" do

    before :each do
      @mp = Multiproc.new ['pwd']
    end

    it "should succeed" do
      lambda {
        @mp.start
      }.should_not raise_exception
    end

  end

  describe "wait" do

    before :each do
      @mp = Multiproc.new [ 'pwd' ]
      @mp.start
    end

    it "should populate the statuses array" do
      @mp.wait
      @mp.statuses.class == 'Array'
    end
  end

  describe "check" do

    before :each do
      @mp = Multiproc.new [ 'sleep 1' ]
      @mp.start
    end

    context "before processes complete" do
      it "should return 1 process running" do
        @mp.check.should eq(1)
      end
    end

    context "after processes complete" do
      it "should return 0 process running" do
        sleep 1.1
        @mp.check.should eq(0)
      end
    end
  end

end

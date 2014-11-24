require 'rails'
require 'spec_helper'
require 'merja'

describe Merja do
  before do
    allow(::Rails).to receive(:root).and_return(Pathname.new("./spec/dummy_merja/").expand_path)
    #Merja.stub(:accessible_dir).and_return(Pathname.new("/dummy/public/"))
  end

  describe "#target_pathname" do
    subject { Merja.__send__(:target_pathname, "hoge") }
    it { should == Pathname.new("./spec/dummy_merja/public/hoge").expand_path }
  end
end

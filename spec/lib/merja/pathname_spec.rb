require 'rails'
require 'spec_helper'
require 'merja'

describe Merja::Pathname do
  describe Merja::Pathname::Json do
    let(:file) { described_class.new("spec/dummy_merja/public/json/test.json") }
    describe "#to_hash" do
      subject { file.to_hash }
      it { should == {"teststr" => "test", "testnum" => 1} }
    end
  end
end

require 'rails'
require 'spec_helper'
require 'merja'

describe Merja do
  before { allow(::Rails).to receive(:root).and_return(Pathname.new("./spec/dummy_merja/").expand_path) }

  describe "#survey" do
    subject { Merja.survey(path) }

    context "pathが存在するフォルダ名で、中のファイルが対応している拡張子の場合" do
      let(:path) { "json" }
      it { should == [{"teststr" => "test", "testnum" => 1}] }
    end

    context "pathが存在するフォルダ名で、中のファイルが対応していない拡張子の場合" do
      let(:path) { "hoge" }
      it { should == [] }
    end

    context "pathが存在しないフォルダ名の場合" do
      let(:path) { "notfound" }
      it { expect { subject }.to raise_error Merja::NotFoundError }
    end

    context "pathが存在するファイル名の場合" do
      let(:path) { "merja/test.txt" }
      it { expect { subject }.to raise_error Merja::NotFoundError }
    end

    context "pathが存在するフォルダ名だがpublic配下でない場合" do
      let(:path) { "../app" }
      it { expect { subject }.to raise_error Merja::ForbiddenError }
    end
  end

  describe "#target_pathname" do
    subject { Merja.__send__(:target_pathname, "hoge") }
    it { should == Pathname.new("./spec/dummy_merja/public/hoge").expand_path }
  end

  describe "#sanitize" do
    subject { Merja.__send__(:sanitize, Pathname.new(path).expand_path) }

    context "pathがpublic配下の場合" do
      let(:path) { "./spec/dummy_merja/public/hoge" }
      it { should == Pathname.new(path).expand_path }
    end

    context "pathがpublic配下でない場合" do
      let(:path) { "./spec/dummy_merja/app" }
      it { expect { subject }.to raise_error Merja::ForbiddenError }
    end

    context "pathに../を使用してディレクトリトラバーサルしようとした場合" do
      let(:path) { "./spec/dummy_merja/public/../../" }
      it { expect { subject }.to raise_error Merja::ForbiddenError }
    end
  end
end

describe Pathname do
  DUMMY_PATH = "./spec/dummy_merja/public/"
  describe "#to_merja" do
    subject { Pathname.new(path).to_merja }

    context "jsonファイルの場合" do
      let(:path) { DUMMY_PATH + "json/test.json" }
      it { should be_instance_of Merja::Pathname::Json }
    end

    context "非対応拡張子のファイルの場合" do
      let(:path) { DUMMY_PATH + "hoge/hoge.hoge" }
      it { should be_nil }
    end

    context "拡張子がないファイルの場合" do
      let(:path) { DUMMY_PATH + "hoge/noext" }
      it { should be_nil }
    end
  end
end
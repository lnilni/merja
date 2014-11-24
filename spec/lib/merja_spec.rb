require 'rails'
require 'spec_helper'
require 'merja'

describe Merja do
  before { allow(::Rails).to receive(:root).and_return(Pathname.new("./spec/dummy_merja/").expand_path) }

  describe "#survey" do
    subject { Merja.survey(path) }

    context "pathが存在するフォルダ名" do
      let(:path) { "merja" }
      it { should == [(::Rails.root + "public/merja/test.txt")] }
    end

    context "pathが存在しないフォルダ名" do
      let(:path) { "notfound" }
      it { expect { subject }.to raise_error Merja::NotFoundError }
    end

    context "pathが存在するファイル名" do
      let(:path) { "merja/test.txt" }
      it { expect { subject }.to raise_error Merja::NotFoundError }
    end

    context "pathが存在するフォルダ名だがpublic配下でない" do
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

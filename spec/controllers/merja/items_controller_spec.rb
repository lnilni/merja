require 'rails_helper'

module Merja
  RSpec.describe ItemsController, :type => :controller do
    routes { Merja::Engine.routes }

    describe "#show" do
      before { get :show, a: path }

      context "ファイルがない場合" do
        let(:path) { "controller/none" }
        it { expect(response).to have_http_status(404) }
      end

      context "上のディレクトリを参照された場合" do
        let(:path) { "../../app" }
        it { expect(response).to have_http_status(403) }
      end

      context "ファイルがある場合" do
        let(:path) { "controller/items" }
        it { expect(response).to have_http_status(200) }
        it do
          expect(JSON.parse(response.body)).to eq({
            "items" => [
              {"teststr" => "test","testnum" => 1},
              {"teststr" => "hoge","testnum" => 2}
            ]
          })
        end
      end
    end
  end
end

require_dependency "merja/application_controller"

module Merja
  class ItemsController < ApplicationController
    def show
      hash = { items: Merja.survey(request.path_info.gsub(/^\//,"")) }
      render json: hash.to_json
    rescue Merja::ForbiddenError
      render nothing: true, status: 403
    rescue Merja::NotFoundError
      render nothing: true, status: 404
    end
  end
end

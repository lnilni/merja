require "merja/engine"

module Merja
  class << self
    def target_pathname(path)
      ::Pathname.new(accessible_dir + path)
    end

    def accessible_dir
      ::Rails.root + "public/"
    end
  end
end

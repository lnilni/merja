require "merja/engine"

module Merja
  class ForbiddenError < StandardError ; end
  class NotFoundError < StandardError ; end

  class << self
    def survey(path)
      target = target_pathname(path)
      target = sanitize(target)

      raise NotFoundError unless target.exist? && target.directory?
      target.children
    end

  private
    def target_pathname(path)
      ::Pathname.new(accessible_dir + path)
    end

    def sanitize(pathname)
      cleanpath = pathname.cleanpath
      raise ForbiddenError if cleanpath.to_s !~ %r(^#{accessible_dir.cleanpath.to_s})
      cleanpath
    end

    def accessible_dir
      ::Rails.root + "public/"
    end
  end
end

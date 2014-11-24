module Merja::Pathname
  class Json < ::Pathname
    def to_hash
      File.open(self.to_s) do |io|
        JSON.load(io)
      end
    end
  end
end

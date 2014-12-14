module Merja::Pathname
  class Json < ::Pathname
    def to_hash
      name = self.basename(".*").to_s
      extname = self.extname.gsub(".","")
      body = File.open(self.to_s) { |io| JSON.load(io) }

      {
        "name" => name,
        "type" => extname,
        "body" => body,
      }
    end
  end
end

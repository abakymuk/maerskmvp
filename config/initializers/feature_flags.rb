module Flags
  def self.real_api?
    ENV["REAL_API"] == "true"
  end
end

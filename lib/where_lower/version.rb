# frozen_string_literal: true

module WhereLower
  # String form of version, to be parsed by Gem::Version
  VERSION = "0.3.4"

  # Return a version object instead of just a string for easier comparison
  #
  # @return [Gem::Version]
  def self.version
    Gem::Version.new(VERSION)
  end
end

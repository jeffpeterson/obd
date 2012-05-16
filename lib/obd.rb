require "serialport"

require_relative "obd/command"
require_relative "obd/connection"

module OBD
  def self.connect *args
    self::Connection.new(*args)
  end
end

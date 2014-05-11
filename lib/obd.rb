require "serialport"

require_relative "obd/command"
require_relative "obd/connection"

module OBD
  class ConnectionFailed < StandardError
  end

  def self.connect *args
    self::Connection.new(*args)
    connection = self::Connection.new(*args)
    return connection, nil
  rescue Errno::EHOSTDOWN
  	return nil, ConnectionFailed.new('Could not connect to OBD2 adapter.')
  end
end

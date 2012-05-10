require "serialport"
require_relative "obd_command"

class OBD

  def initialize port, baud = 9600
    @port = port
    @baud = baud

    connect
  end
  
  def voltage
    send("AT RV")
  end
  
  def connect
    @serial_port = SerialPort.new @port, @baud # , data_bits: 8, stop_bits: 1, parity: SerialPort::NONE
    @serial_port.read_timeout = 5000
    read
    send("AT E0")    # turn echo off
    send("AT L0")    # turn linefeeds off
    send("AT S0")    # turn spaces off
    send("AT AT2")   # respond to commands faster
    send("AT SP 00") # automatically select protocol
  end

  def [] command
    ObdCommand.format_result(command, send(ObdCommand.to_hex(command)))
  end
  
  def send data
    write data
    read
  end
  
  private

  def read
    return @serial_port.gets("\r\r>").to_s.chomp("\r\r>")
  end
  
  def write data
    @serial_port.write data.to_s + "\r"
  end
end

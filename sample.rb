# require 'obd_response'
require_relative "obd"

obd = OBD.new "/dev/tty.OBDII-DevB", 38400

loop do
  puts obd[ gets.chomp.strip ].inspect
  # puts obd[ :timing_advance ]
end

loop do
  puts "" +
    [
      [
        obd[:engine_rpm],
        obd[:vehicle_speed],
        obd.voltage
      ],
      [
        obd[:engine_coolent_temperature],
        obd[:calculated_engine_load]
      ],
      [
        obd[:throttle_position],
        obd[:aux_input_status]
      ]
    ].map{|x|x.join("\t")}.join("\n")
end

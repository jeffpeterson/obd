# require 'obd_response'
require_relative "lib/obd"

obd = OBD.connect "/dev/tty.OBDII-DevB", 38400

#loop do
#  + obd[ gets.chomp.strip ].inspect
  # + obd[ :timing_advance ]
#end

loop do
  puts obd[:engine_rpm],
    obd[:vehicle_speed],
    obd.voltage,
    obd[:engine_coolent_temperature] + " - Engine Coolant Temperature",
    obd[:calculated_engine_load] + " - Calculated Engine Load",
    obd[:throttle_position] + " - Throttle Position",
    obd[:aux_input_status] + " - Aux input status",
    '-------------------------------'
end

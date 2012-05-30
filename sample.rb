require 'obd'

obd = OBD.connect "/dev/tty.obd", 38400

loop do
  puts obd[:engine_rpm],
    obd[:vehicle_speed],
    obd.voltage,
    obd[:timing_advance]             + " - Timing Advance",
    obd[:engine_coolent_temperature] + " - Engine Coolant Temperature",
    obd[:calculated_engine_load]     + " - Calculated Engine Load",
    obd[:throttle_position]          + " - Throttle Position",
    obd[:aux_input_status]           + " - Aux input status",
    '-------------------------------'
end

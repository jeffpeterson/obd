require 'obd'

err = true
while err do
	puts 'Connecting to OBD2 adapter...'
	# obd, err = OBD.connect "/dev/tty.obd", 38400
	obd, err = OBD.connect "/dev/tty.usbserial-FTDI_A", 9600
	sleep 1
end



loop do
  puts obd[:engine_rpm],
    obd[:vehicle_speed],
    obd.voltage,
    obd[:timing_advance]             + " - Timing Advance",
    obd[:engine_coolant_temperature] + " - Engine Coolant Temperature",
    obd[:calculated_engine_load]     + " - Calculated Engine Load",
    obd[:throttle_position]          + " - Throttle Position",
    obd[:aux_input_status]           + " - Aux input status",
    '-------------------------------'
end

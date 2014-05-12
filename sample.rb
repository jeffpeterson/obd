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
    obd[:timing_advance]             	+ " - Timing Advance",
    obd[:engine_coolant_temperature] 	+ " - Engine Coolant Temperature",
    obd[:calculated_engine_load]     	+ " - Calculated Engine Load",
    obd[:throttle_position]          	+ " - Throttle Position",
    obd[:warmups_since_codes_cleared] 	+ " - Warmups since codes cleared",
    obd[:distance_traveled_with_mil_on]	+ " - Distance traveled with MIL on",
    obd.send('4D') 						+ " - Time run with MIL on",
    '-------------------------------'
end

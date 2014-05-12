module OBD
  class Command

    def initialize

    end

    def self.format_result command, result
      if result == nil || result == ''
        puts "Communication error: No data received. Check serial connection..."
        puts "Data returned: '#{result}'"
        return ""
      end
      if is_command?(command) && result != "NO DATA"
        # puts "Data returned: '#{result}'"
        pids[command.to_sym].call h(result), h(result).to_i(16)
      else
        result
      end
    end

    def self.to_hex command
      if is_command? command
        "01%02x" % pids.keys.index(command.to_sym)
      else
        command
      end
    end

    def self.is_command? command
      pids.keys.include? command.to_sym
    end

    def self.pid
      {
        "atrv" => [:battery_voltage, lambda {|x| x.to_s}],
        "0100" => [:pids_supported_1]
      }
    end

    def self.pids
      {
        # Note: Not all of these lambda's need the second parameter but without it, this code does
        # not work correctly. So, you'll sometimes see a useless parameter being handed in. This is
        # just to get the code working. There may be an easier way to handle this in format_result
        pids_supported_1:                      lambda {|x,d| d.to_s(2).split('').each_with_index.map{|b,i| pids.keys[i] if b == '1'}},
        monitor_status_since_clear:            lambda {|x,d| x},
        freeze_dtc:                            lambda {|x,d| x},
        fuel_system_status:                    lambda {|x,d| x},
        calculated_engine_load:                lambda {|x,d| "%0.2f" % (d * 100.0 / 255.0) + '%'},
        engine_coolant_temperature:            lambda {|x,d| "%0.2f" % (d * 1.8 - 104) + '*F'},
        short_term_fuel_trim_bank_1:           lambda {|x,d| "%0.2f" % (d * 0.78125 - 100) + '%'},
        long_term_fuel_trim_bank_1:            lambda {|x,d| "%0.2f" % (d * 0.78125 - 100) + '%'},
        short_term_fuel_trim_bank_2:           lambda {|x,d| "%0.2f" % (d * 0.78125 - 100) + '%'},
        long_term_fuel_trim_bank_2:            lambda {|x,d| "%0.2f" % (d * 0.78125 - 100) + '%'},
        fuel_pressure:                         lambda {|x,d| "%0.2f" % (d * 3 * 0.145) + 'psi'},
        intake_manifold_absolute_pressure:     lambda {|x,d| "%0.2f" % (d * 0.145) + 'psi'},
        engine_rpm:                            lambda {|x,d| "%0.2f" % (d / 4.0) + 'rpm'},
        vehicle_speed:                         lambda {|x,d| "%0.2f" % (d * 0.621371192) + 'mph'},
        timing_advance:                        lambda {|x,d| "%0.2f" % (d / 2.0 - 64) + '*'},
        intake_air_temperature:                lambda {|x,d| "%0.2f" % (d * 1.8 - 104) + '*F'},
        maf_air_flow_rate:                     lambda {|x,d| "%0.2f" % (d / 100.0) + 'grams/sec'},
        throttle_position:                     lambda {|x,d| "%0.2f" % (d * 100 / 255.0) + '%'},
        commanded_secondary_air_status:        lambda {|x,d| x}, # bit encoded
        oxygen_sensors_present:                lambda {|x,d| x}, # [A0..A3] == Bank 1,Sensors 1-4.[A4..A7]
        bank_1_sensor_1_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_1_sensor_2_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_1_sensor_3_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_1_sensor_4_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_2_sensor_1_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_2_sensor_2_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_2_sensor_3_oxygen_sensor_voltage: lambda {|x,d| x},
        bank_2_sensor_4_oxygen_sensor_voltage: lambda {|x,d| x},
        obd_standards_vehicle_conforms_to:     lambda {|x,d| x}, # bit encoded
        oxygen_sensors_present_2:              lambda {|x,d| x}, # complicated... similar to oxygen_sensors_present
        aux_input_status:                      lambda {|x,d| (x == 1).inspect}, # Power Take Off (PTO) status is active?
        run_time_since_engine_start:           lambda {|x,d| d}, # seconds
        pids_supported_2:                      lambda {|x,d| d.to_s(2).split('').each_with_index.map{|b,i| pids.keys[i+33] if b == '1'}}, # bit encoded
        distance_traveled_with_mil_on:         lambda {|x,d| d.to_s + 'km'},

        # Added by JamesHagerman:
        fuel_rail_pressure_manifold:           lambda {|x,d| "%0.2f" % (d * 0.079) + 'kPa'},
        fuel_rail_pressure:                    lambda {|x,d| "%0.2f" % (d * 10) + 'kPa (gauge)'},

        # O2 sensors are returned as both a ratio and a voltage:
        o2s1_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s2_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s3_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s4_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s5_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s6_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s7_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},
        o2s8_wd_lambda:                        lambda {|x,d| d.to_s(2).rjust(16,'0').scan(/.{8}/).each_with_index.map{|b,i| case i; when 0; "%0.2f" % ( b.to_i(2)/32768) + ' (ratio)'; else; "%0.2f" % (b.to_i(2)/8192) + 'v'; end;}},

        commanded_egr:                         lambda {|x,d| "%0.2f" % (d * 100.0 / 255.0) + '%'},
        egr_error:                             lambda {|x,d| "%0.2f" % ((d - 128.0) * 100.0 / 128.0) + '%'},
        commanded_evaporative_purge:           lambda {|x,d| "%0.2f" % (d * 100.0 / 255.0) + '%'},
        fuel_level_input:                      lambda {|x,d| "%0.2f" % (d * 100.0 / 255.0) + '%'},
        warmups_since_codes_cleared:           lambda {|x,d| d.to_s},
        distance_traveled_since_codes_cleared: lambda {|x,d| d.to_s + 'km'}
        # Done added by JamesHagerman

      }
    end

    def self.h response
      response[4..-1]
    end


  end
end

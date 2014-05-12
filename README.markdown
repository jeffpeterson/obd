About
=====

This gem has been updated so that it should support the Sparkfun OBD II UART board (https://www.sparkfun.com/products/9555) without modification.

It should also work with any other OBD II scanners that follow the ELM327 standard as well.

Installation
============
~~~ text
gem install obd
~~~

Usage
=====

Connect your OBD-II adapter and pass its device file to `OBD.connect`:

~~~ ruby
require 'obd'

obd, err = OBD.connect '/dev/tty.obd' 9600

obd[:engine_rpm]
=> "4367.25rpm"

# Retrieve error codes
obd.send("03")
=> "43000545"
~~~


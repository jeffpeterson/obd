Installation
============
~~~ console
gem install obd
~~~

Usage
=====

Connect your OBD-II adapter and pass the 
~~~ ruby
require 'obd'

obd = OBD.connect '/dev/tty.obd'

obd[:engine_rpm]
#=> "4367.25rpm"

# Retrieve error codes
obd.send("03")
#=> "43000545"
~~~


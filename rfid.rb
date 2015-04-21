require "serialport"
class RfidReader
 attr_accessor :key

 def initialize(port)
   port_str = port
   baud_rate = 9600
   data_bits = 8
   stop_bits = 1
   parity = SerialPort::NONE
   @sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
   @key_parts = []
   @key_limit = 16 # number of slots in the RFID card.
   while true do
     main
   end
   @sp.close
 end

 def key_detected?
   @key_parts << @sp.getc
   if @key_parts.size >= @key_limit
     self.key = @key_parts.join()
     @key_parts = []
     true
   else
     false
   end
 end

 def main
   if key_detected?
     puts self.key
   end
 end
end

RfidReader.new("/dev/cu.usbserial-A900ftPb")

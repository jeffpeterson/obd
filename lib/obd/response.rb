module OBD
  class Response
    attr_accessor :type
    
    def initialize _hex_response, last_command
      @hex_response = _hex_response
    end
    
    def to_s
      value.to_s
    end
    
    def value
      @hex_response.[4..-1]
    end
      
  end
end

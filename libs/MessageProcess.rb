require 'json'

class MessageProcess

    def initialize(status)
        @status_list = status
    end

    def message(topic, message)
        puts "*********************"
        puts "#{topic}: #{message}"
        puts "*********************"
    
        process_data(JSON.parse(message))
    end

    private

    def process_data(data)
        case data["action"]
        when "flip90", "flip180"
            current_side = data["side"]
            @status_list["side_#{current_side}"]
        when "shake"
            @status_list["shake"]
        end
    end

end
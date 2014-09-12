require 'net/smtp'

module Resque
  module Failure
    # Send an email to the developer, so we know something went wrong.
    class Notifier < Base
 
      class << self
        attr_accessor :smtp, :sender, :recipients
      end
 
      def self.configure
        yield self
        Resque::Failure.backend = self unless Resque::Failure.backend == Resque::Failure::Multiple
      end
 
      def save
        # Create the notification email about the exception
        msgstr = <<END_OF_MESSAGE
Subject: [Resque - Error in Resala resque worker] #{exception}
 
Queue:    #{queue}
Worker:   #{worker}
 
#{payload.inspect}
 
#{exception}
#{exception.backtrace.join("\n")}
END_OF_MESSAGE

        smtp = Net::SMTP.new 'smtp.gmail.com', 587
        smtp.enable_starttls
        smtp.start('resala.org', "espace.resala.dev@gmail.com", 'R3$@l@M@$R', :login) do
          smtp.send_message(msgstr, self.class.sender, self.class.recipients)
        end

      rescue Exception => exc
        puts exc.inspect
      end
    end
  end
end
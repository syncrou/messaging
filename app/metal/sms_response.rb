require 'sinatra'

class SmsResponse < Sinatra::Base

  get '/' do
    "Hello SMS"
  end
end

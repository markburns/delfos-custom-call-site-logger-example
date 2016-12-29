class SourceCodeChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'source_code'
  end
end

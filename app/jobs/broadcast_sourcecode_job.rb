class BroadCastSourcecodeJob < ApplicationJob
  self.queue_adapter = :sucker_punch

  queue_as :default

  def perform(parameters)
    ActionCable.server.broadcast 'source_code', parameters
  end
end

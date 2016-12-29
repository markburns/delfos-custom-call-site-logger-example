require_dependency "lib/delfos_websocket_logger"

Delfos.setup! \
  logger: Rails.logger,
  call_site_logger: DelfosWebsocketLogger.new,
  application_directories: %w(app)

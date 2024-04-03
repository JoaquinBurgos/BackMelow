require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Scheduler.enabled = true
    Sidekiq::Scheduler.reload_schedule!
  end
end
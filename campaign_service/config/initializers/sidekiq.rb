Sidekiq.configure_server do |config|
	config.redis = { url: 'redis://localhost:6379/0' }
	schedule_file = "config/sidekiq_scheduler.yml"
	if File.exist?(schedule_file)
		Sidekiq::Scheduler.reload_schedule!
	end
end
  
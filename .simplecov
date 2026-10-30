# Unused Rails boilerplate. Remove these skips if we start using jobs or mailers.
SimpleCov.coverage_dir ENV.fetch("COVERAGE_DIR", "coverage")
SimpleCov.skip "/features/"
SimpleCov.skip "/app/jobs/application_job.rb"
SimpleCov.skip "/app/mailers/application_mailer.rb"

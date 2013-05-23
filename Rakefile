#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

RedBeard::Application.load_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end
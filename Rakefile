#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CoverStory::Application.load_tasks


# for minitest spec
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

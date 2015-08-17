# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zensend/version'

Gem::Specification.new do |s|
  s.name         = 'zensend'
  s.version      = ZenSend::VERSION
  s.date         = '2015-04-23'
  s.summary      = "ZenSendr's REST API"
  s.description  = "A simple REST API for ZenSend in Ruby"
  s.author       = "Fonix"
  s.email        = 'tech@fonix.com'
  s.files        = Dir.glob("lib/**/*")
  s.require_path = 'lib'
  s.homepage     = 'http://rubygems.org/gems/zensend_ruby_api'
  s.license      = 'MIT'


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'
end

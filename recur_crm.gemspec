lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recur_crm/version'

Gem::Specification.new do |spec|
  spec.name                   = 'recurcrm'
  spec.version                = RecurCrm::VERSION
  spec.authors                = ['Recur CRM', 'Rich Chetwynd']
  spec.email                  = ['support@recurcrm.com']

  spec.summary                = 'Ruby SDK for Recur CRM'
  spec.description            = 'Use Recur for SaaS subscription management, quoting, billing and CRM'
  spec.homepage               = 'https://github.com/recurcrm/recur-ruby'
  spec.license                = 'MIT'
  spec.platform               = Gem::Platform::RUBY
  spec.required_ruby_version  = '>= 2.5.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 3.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.20'
  spec.add_runtime_dependency 'json', '~> 2.6'

  spec.add_development_dependency 'fakeweb', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 1.26'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.9'
end

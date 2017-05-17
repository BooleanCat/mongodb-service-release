RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) {
    check_bosh_envs
    check_bosh_gateway_envs
  }
end

def check_bosh_envs
  envs = ['BOSH_ENVIRONMENT', 'BOSH_CA_CERT', 'BOSH_CLIENT', 'BOSH_CLIENT_SECRET', 'BOSH_DEPLOYMENT']
  failure_message = 'configure BOSH envs in `.envrc` or manually'

  envs.each do |env|
    expect(ENV[env]).not_to be_empty, failure_message
  end
end

def check_bosh_gateway_envs
  if gateway_configured?
    failure_message = 'set all of BOSH_GW_HOST, BOSH_GW_USER, BOSH_GW_PRIVATE_KEY to configure a gateway'

    expect(ENV['BOSH_GW_HOST']).not_to be_empty, failure_message
    expect(ENV['BOSH_GW_USER']).not_to be_empty, failure_message
    expect(ENV['BOSH_GW_PRIVATE_KEY']).not_to be_empty, failure_message
  end
end

def gateway_configured?
  !ENV['BOSH_GW_HOST'].empty? \
  or !ENV['BOSH_GW_USER'].empty? \
  or !ENV['BOSH_GW_PRIVATE_KEY'].empty?
end

require 'json'
require 'net/ssh/gateway'
require 'mongo'

MONGODB_DEFAULT_PORT = 27017

describe 'mongodb' do
  before(:all) do
    Mongo::Logger.logger.level = ::Logger::FATAL
  end

  let(:gateway) {
    gateway = Net::SSH::Gateway.new(
      ENV.fetch('BOSH_GW_HOST'),
      ENV.fetch('BOSH_GW_USER'),
      :keys => [ENV.fetch('BOSH_GW_PRIVATE_KEY')],
    )
  }

  let(:private_host) {
    instances = JSON.parse %x( bosh instances --json )
    instances['Tables'].first['Rows'].find { |row| row['instance'].start_with? 'mongodb' }['ips']
  }

  let(:host) {
    if @gateway_configured
      return '127.0.0.1'
    end

    private_host
  }

  let(:port) {
    if @gateway_configured
      return gateway.open(private_host, MONGODB_DEFAULT_PORT)
    end

    MONGODB_DEFAULT_PORT
  }

  it 'is pingable' do
    client = Mongo::Client.new("mongodb://#{host}:#{port}/test")
    expect(client.command(ping: 1).successful?).to be true
  end
end

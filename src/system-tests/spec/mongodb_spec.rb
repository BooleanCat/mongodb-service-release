require 'json'
require 'net/ssh/gateway'
require 'mongo'

MONGODB_DEFAULT_PORT = 27017

describe 'mongodb' do
  before(:all) do
    Mongo::Logger.logger.level = ::Logger::FATAL
  end

  let(:mongodb_host) {
    instances = JSON.parse %x( bosh instances --json )
    instances['Tables'].first['Rows'].find { |row| row['instance'].start_with? 'mongodb' }['ips']
  }

  let (:mongodb_port) {
    gateway = Net::SSH::Gateway.new(
      ENV.fetch('BOSH_GW_HOST'),
      ENV.fetch('BOSH_GW_USER'),
      :keys => [ENV.fetch('BOSH_GW_PRIVATE_KEY')],
    )
    gateway.open(mongodb_host, MONGODB_DEFAULT_PORT)
  }

  it 'is pingable' do
    client = Mongo::Client.new("mongodb://127.0.0.1:#{mongodb_port}/test")
    expect(client.command(ping: 1).successful?).to be true
  end
end

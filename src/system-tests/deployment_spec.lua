json = require('cjson')
mongorover = require('mongorover')
require('bosh')

describe('deployment', function()
  setup(function()
    mongodb_ssh = BoshSSH:new('mongodb', 0)
    address = string.format('mongodb://%s:27017', get_deployment_ip())
  end)

  describe('mongodb', function()
    it('is pingable', function()
      local client = mongorover.MongoClient.new(address)
      local database = client:getDatabase('foo')
      database:command('ping')
    end)

    it('is of the expected version', function()
      local output = mongodb_ssh:exec('/var/vcap/packages/mongodb/bin/mongod --version')
      local version = output:match('db version v3.4.4')
      assert.is_not_nil(version)
    end)
  end)
end)

function get_deployment_ip()
  local handler = io.popen('bosh --json instances')
  local instances = json.decode(handler:read('*a'))
  return instances.Tables[1].Rows[1].ips
end

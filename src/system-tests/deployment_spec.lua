local moonscript = require("moonscript")
local json = require('cjson')
local mongorover = require('mongorover')
local bosh = require('bosh')

describe('deployment', function()
  setup(function()
    mongodb_ssh = bosh.SSH('mongodb', 0)
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
      local found = string.find(output, 'db version v3.4.4')
      assert.is_not_nil(found)
    end)

    describe('configuration', function()
      setup(function()
        mongodb_log = mongodb_ssh:exec('cat /var/vcap/sys/log/mongodb/mongod.log')
      end)

      it('logs to the expected file', function()
        local found = string.find(mongodb_log, 'MongoDB starting')
        assert.is_not_nil(found)
      end)

      it('disables transparent_hugepage', function()
        local found = string.find(mongodb_log, 'WARNING: /sys/kernel/mm/transparent_hugepage')
        assert.is_nil(found)
      end)

      it('considers soft limits sufficiently high', function()
        local found = string.find(mongodb_log, 'WARNING: soft rlimits too low.')
        assert.is_nil(found)
      end)
    end)
  end)
end)

function get_deployment_ip()
  local handler = io.popen('bosh --json instances')
  local instances = json.decode(handler:read('*a'))
  return instances.Tables[1].Rows[1].ips
end

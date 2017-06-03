json = require('cjson')
mongorover = require('mongorover')

describe('deployment', function()
  setup(function()
    address = string.format('mongodb://%s:27017', get_deployment_ip())
  end)

  describe('mongodb', function()
    it('is pingable', function()
      local client = mongorover.MongoClient.new(address)
      local database = client:getDatabase('foo')
      database:command('ping')
    end)
  end)
end)

function get_deployment_ip()
  local handler = io.popen('bosh --json instances')
  local instances = json.decode(handler:read('*a'))
  return instances.Tables[1].Rows[1].ips
end

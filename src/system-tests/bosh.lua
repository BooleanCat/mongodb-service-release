json = require('cjson')

BoshSSH = {}
local BoshSSH_mt = { __index = BoshSSH }

function BoshSSH:new(job, node)
  return setmetatable({job=job, node=node}, BoshSSH_mt)
end

function BoshSSH:exec(command)
  local handler = io.popen(self:make_command(command))
  local output = json.decode(handler:read('*a')).Blocks
  return self:parse(output)
end

function BoshSSH:make_command(command)
  return string.format('bosh --json ssh %s/%s "%s"', self.job, self.node, command)
end

function BoshSSH:parse(output)
  local bosh_stdout = ''

  for i,v in pairs(output) do
    if self:is_stdout_line(v) then
      bosh_stdout = bosh_stdout .. output[i+1] .. "\n"
    end
  end

  return bosh_stdout
end

function BoshSSH:is_stdout_line(line)
  local match = line:match(': stdout | ')
  return match ~= nil
end

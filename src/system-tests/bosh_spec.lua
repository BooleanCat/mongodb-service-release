local moonscript = require("moonscript")
local bosh = require('bosh')

describe('bosh', function()
  before_each(function()
    mongodb_ssh = bosh.SSH('mongodb', 0)
  end)

  describe('#make_command', function()
    it('correctly constructs a bosh command', function()
      local command = mongodb_ssh:make_command('echo foo')
      local expected_command = "bosh --json ssh mongodb/0 'echo foo'"
      assert.are.equal(expected_command, command)
    end)
  end)

  describe('#is_stdout_line', function()
    it('correctly identifies a stdout line', function()
      local line = 'mongodb/4e5d176e-003a-4b8b-a844-11540ae17c96: stdout | '
      local found = mongodb_ssh:is_stdout_line(line)
      assert.is_true(found)
    end)

    it('correctly identifies a non-stdout line', function()
      local line = 'mongodb/4e5d176e-003a-4b8b-a844-11540ae17c96: stderr |'
      local found = mongodb_ssh:is_stdout_line(line)
      assert.is_false(found)
    end)
  end)

  describe('#parse', function()
    before_each(function()
      bosh_ssh_output = io.open('fixtures/bosh_ssh_output.json'):read('*a')
    end)

    it('collects stdout_lines from a bosh output', function()
      local parsed = mongodb_ssh:parse(bosh_ssh_output)
      local expected = "foo\nbar"
      assert.are.equal(expected, parsed)
    end)
  end)
end)

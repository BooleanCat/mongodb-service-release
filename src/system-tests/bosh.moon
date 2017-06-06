json = require 'cjson'

class SSH
  new: (job, node) =>
    @job = job
    @node = node

  exec: (command) =>
      handler = io.popen(@make_command(command))
      @parse(handler\read('*a'))

  parse: (output) =>
    json_output = json.decode(output).Blocks
    stdout_lines = [@trim(json_output[i+1]) for i, line in ipairs json_output when @is_stdout_line(line)]
    table.concat(stdout_lines, '\n')

  trim: (s) =>
    s\match('^%s*(.-)%s*$')

  is_stdout_line: (line) =>
    line\find(': stdout | ') ~= nil

  make_command: (command) =>
    "bosh --json ssh #{@job}/#{@node} '#{command}'"

{ :SSH }

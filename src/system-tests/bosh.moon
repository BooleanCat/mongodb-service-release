json = require 'cjson'

class BoshSSH
  new: (job, node) =>
    @job = job
    @node = node

  exec: (command) =>
      handler = io.popen(@make_command(command))
      output = json.decode(handler\read('*a')).Blocks
      @parse(output)

  parse: (output) =>
    stdout_lines = [output[i+1] for i, line in ipairs output when @is_stdout_line(line)]
    table.concat(stdout_lines, '\n')

  is_stdout_line: (line) =>
    line\match(': stdout | ') ~= nil

  make_command: (command) =>
    "bosh --json ssh #{@job}/#{@node} '#{command}'"

{ :BoshSSH }

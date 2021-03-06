# frozen_string_literal: true

require_relative '../../src/parser'

# This function will poll $stdin for 2 seconds and attempt to gather up every
# line until it hits a "---" line. At that point it will return everything
# joined together. If it does not receive input within 2 seconds, it will bail
# out and return `nil`.
def gather
  return unless select([$stdin], nil, nil, 2)

  lines, line = [], nil
  while (line = gets) != "---\n"
    lines << line
  end
  lines.join
end

# This process will loop infinitely, gathering up lines from stdin, parsing them
# with Prettier::Parser, and then returning the parsed AST over stdout.
loop do
  gathered = gather
  next unless gathered

  parser = Prettier::Parser.new(gathered)

  STDOUT.puts JSON.fast_generate(parser.parse)
  STDOUT.flush
end

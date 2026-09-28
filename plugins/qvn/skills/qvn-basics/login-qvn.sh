#!/bin/sh
# Claude Code's `mcp login` needs a terminal; run it under a pseudo-terminal so an agent can drive it.
python3 -c 'import pty,sys; pty.spawn(sys.argv[1:])' claude mcp login plugin:qvn:qvn

.PHONY: build test server format

server s:
	mix phx.server

format f:
	mix format

build b:
	mix setup

test t:
	mix test

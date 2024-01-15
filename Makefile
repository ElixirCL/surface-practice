.PHONY: build test server format deps

server s:
	mix phx.server

format f:
	mix format

deps d:
	mix deps.get

build b:
	mix setup

test t:
	mix test

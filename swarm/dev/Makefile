.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/glyff/glyff-node/cmd/swarm
	go build -o bin/glyff     github.com/glyff/glyff-node/cmd/glyff
	go build -o bin/bootnode github.com/glyff/glyff-node/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/glyff/glyff-node/swarm/...

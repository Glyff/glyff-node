# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: glyff android ios glyff-cross swarm evm all test clean
.PHONY: glyff-linux glyff-linux-386 glyff-linux-amd64 glyff-linux-mips64 glyff-linux-mips64le
.PHONY: glyff-linux-arm glyff-linux-arm-5 glyff-linux-arm-6 glyff-linux-arm-7 glyff-linux-arm64
.PHONY: glyff-darwin glyff-darwin-386 glyff-darwin-amd64
.PHONY: glyff-windows glyff-windows-386 glyff-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

zsl:
	cd vendor/github.com/jpmorganchase/zsl-q/zsl-golang/zsl/snark/ ; $(MAKE)
	@echo "Done building libzsl.a"

glyff: zsl
	build/env.sh go run build/ci.go install ./cmd/glyff
	@echo "Done building."
	@echo "Run \"$(GOBIN)/glyff\" to launch glyff."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all: zsl
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/glyff.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Glyff.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

glyff-cross: glyff-linux glyff-darwin glyff-windows glyff-android glyff-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/glyff-*

glyff-linux: glyff-linux-386 glyff-linux-amd64 glyff-linux-arm glyff-linux-mips64 glyff-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-*

glyff-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/glyff
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep 386

glyff-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/glyff
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep amd64

glyff-linux-arm: glyff-linux-arm-5 glyff-linux-arm-6 glyff-linux-arm-7 glyff-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep arm

glyff-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/glyff
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep arm-5

glyff-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/glyff
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep arm-6

glyff-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/glyff
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep arm-7

glyff-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/glyff
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep arm64

glyff-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/glyff
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep mips

glyff-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/glyff
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep mipsle

glyff-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/glyff
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep mips64

glyff-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/glyff
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/glyff-linux-* | grep mips64le

glyff-darwin: glyff-darwin-386 glyff-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/glyff-darwin-*

glyff-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/glyff
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-darwin-* | grep 386

glyff-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/glyff
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-darwin-* | grep amd64

glyff-windows: glyff-windows-386 glyff-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/glyff-windows-*

glyff-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/glyff
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-windows-* | grep 386

glyff-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/glyff
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/glyff-windows-* | grep amd64

#
IMAGE?=quay.io/rimusz/hostpath-provisioner

TAG_GIT=$(IMAGE):v0.2.3
TAG_LATEST=$(IMAGE):latest

PHONY: all
all: image push

PHONY: test-image
test-image:
	docker build -t hostpath-provisioner -f Dockerfile .

PHONY: image
image:
	docker build -t $(TAG_GIT) -f Dockerfile .
	docker tag $(TAG_GIT) $(TAG_LATEST)

PHONY: push
push:
	docker push $(TAG_GIT)
	docker push $(TAG_LATEST)

PHONY: go-mod
go-mod:
	go mod init

PHONY: hostpath-provisioner
hostpath-provisioner: $(shell find . -name "*.go")
	CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o hostpath-provisioner .

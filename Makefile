RELEASE := $(GOPATH)/bin/github-release

$(RELEASE):
	go get -u github.com/aktau/github-release

dist:
ifndef version
	@echo "Please provide a version"
	exit 1
endif
	mkdir -p releases/$(version)
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o releases/$(version)/runsvinit-darwin-amd64
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o releases/$(version)/runsvinit-linux-amd64

release: dist | $(RELEASE)
ifndef version
	@echo "Please provide a version"
	exit 1
endif
ifndef GITHUB_TOKEN
	@echo "Please set GITHUB_TOKEN in the environment"
	exit 1
endif
	# These commands are not idempotent, so ignore failures if an upload repeats
	$(RELEASE) release --user onemedical --repo runsvinit --tag $(version) || true
	$(RELEASE) upload --user onemedical --repo runsvinit --tag $(version) --name runsvinit-linux-amd64 --file releases/$(version)/runsvinit-linux-amd64 || true
	$(RELEASE) upload --user onemedical --repo runsvinit --tag $(version) --name runsvinit-darwin-amd64 --file releases/$(version)/runsvinit-darwin-amd64 || true

# Use Docker to build and render the diagram

IMAGE_NAME=aws-diagrams:latest
WORKDIR=$(shell pwd)

.PHONY: build render shell clean

build:
	docker build -t $(IMAGE_NAME) aws-diagrams

render: build
	# Render the diagram into the repo root so it's easy to find
	docker run --rm -v "$(WORKDIR):/workspace" $(IMAGE_NAME) \
		python aws-diagrams/ai_dev_lab.py
	@echo "Output: $(WORKDIR)/ai_dev_lab_govcloud.png"

shell: build
	docker run --rm -it -v "$(WORKDIR):/workspace" $(IMAGE_NAME) bash

clean:
	rm -f ai_dev_lab_govcloud.png ai_dev_lab_govcloud.dot ai_dev_lab_govcloud.gv


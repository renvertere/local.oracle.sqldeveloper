APP_ID    := local.oracle.sqldeveloper
MANIFEST  := $(APP_ID).yml
IMAGE     := flatpak-builder

BUILD_DIR := build-dir
CACHE_DIR := .flatpak-builder
REPO_DIR  := repo
DIST_DIR  := dist
BUNDLE    := $(DIST_DIR)/$(APP_ID).flatpak

CONTAINER ?= docker
CONTAINER_RUN_FLAGS ?= --rm --privileged

STAMP_DIR := .make
IMAGE_STAMP := $(STAMP_DIR)/image.$(IMAGE).stamp

.PHONY: all image bundle install run clean clean-cache

all: bundle

image: $(IMAGE_STAMP)

$(IMAGE_STAMP): Dockerfile
	@mkdir -p $(STAMP_DIR)
	$(CONTAINER) build -t $(IMAGE) .
	@touch $(IMAGE_STAMP)

bundle: image
	mkdir -p $(REPO_DIR) $(DIST_DIR)
	$(CONTAINER) run $(CONTAINER_RUN_FLAGS) \
		-v $(PWD):/work \
		$(IMAGE) \
		sh -lc '\
			flatpak-builder --force-clean $(BUILD_DIR) $(MANIFEST) && \
			flatpak build-export $(REPO_DIR) $(BUILD_DIR) && \
			flatpak build-bundle $(REPO_DIR) $(BUNDLE) $(APP_ID) master'

install: bundle
	flatpak install --user -y $(BUNDLE)

run:
	flatpak run $(APP_ID)

clean:
	rm -rf $(BUILD_DIR) $(REPO_DIR) $(DIST_DIR) $(STAMP_DIR) $(CACHE_DIR)
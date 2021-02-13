# Variables

PRODUCT_NAME := Comparison
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace
SCHEME_NAME := ${PRODUCT_NAME}

.DEFAULT_GOAL := help

# Targets

.PHONY: setup
setup: # Install dependencies and prepared development configuration
	$(MAKE) install-bundler
	$(MAKE) install-mint
	$(MAKE) generate-xcodeproj
	$(MAKE) generate-licenses

.PHONY: install-bundler
install-bundler: # Install Bundler dependencies
	bundle config path vendor/bundle
	bundle install --jobs 4 --retry 3

.PHONY: update-bundler
update-bundler: # Update Bundler dependencies
	bundle config path vendor/bundle
	bundle update --jobs 4 --retry 3

.PHONY: install-mint
install-mint: # Install Mint dependencies
	mint bootstrap

.PHONY: install-cocoapods
install-cocoapods: # Install CocoaPods dependencies and generate workspace
	bundle exec pod install

.PHONY: update-cocoapods
update-cocoapods: # Update CocoaPods dependencies and generate workspace
	bundle exec pod update

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist and regenerate project
	mint run LicensePlist license-plist --output-path ${PRODUCT_NAME}/Settings.bundle --add-version-numbers
	$(MAKE) generate-xcodeproj

.PHONY: generate-xcodeproj
generate-xcodeproj: # Generate project with XcodeGen
	mint run xcodegen xcodegen generate
	$(MAKE) install-cocoapods

.PHONY: open
open: # Open workspace in Xcode
	open ./${WORKSPACE_NAME}

.PHONY: clean
clean: # Delete cache
	xcodebuild clean -alltargets
	rm -rf ./Pods
	rm -rf ./vendor/bundle

.PHONY: show-devices
show-devices: # Show devices
	instruments -s devices
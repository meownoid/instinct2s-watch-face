KEY_PATH := /Users/meownoid/Documents/My/Keys/garmin-developer.der
DEVICE := instinct2s

SDK_PATH := $(shell cat "$(HOME)/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg")

ifndef VERBOSE
.SILENT:f
endif

clean:
	rm -rf bin/*
	rm -rf out/*

deploy: release
	cp out/watchface-release.prg /Volumes/GARMIN/GARMIN/APPS/

release: out
	"$(SDK_PATH)/bin/monkeyc" -r -w -O3 -d $(DEVICE) -f monkey.jungle -o out/watchface-release.prg -y $(KEY_PATH)

run:
	"$(SDK_PATH)/bin/connectiq"
	"$(SDK_PATH)/bin/monkeydo" bin/watchface.prg instinct2s

build: bin
	"$(SDK_PATH)/bin/monkeyc" -w -d $(DEVICE)_sim -f monkey.jungle -o bin/watchface.prg -y $(KEY_PATH)

bin:
	mkdir -p bin

out:
	mkdir -p out

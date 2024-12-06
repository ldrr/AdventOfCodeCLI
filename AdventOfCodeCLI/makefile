
src=$(shell find . -iname '*.swift' | sed 's/ /\\ /g')

AoC: $(src)
	swiftc -Ounchecked -o optimizedExecutable -whole-module-optimization -swift-version 6 -sdk /Applications/Xcode-16.0.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.sdk -o $@ $^


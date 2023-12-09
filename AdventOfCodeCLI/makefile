
src=$(shell find . -iname '*.swift' | sed 's/ /\\ /g')

AoC: $(src)
	swiftc -swift-version 5 -sdk /Applications/Xcode-15.1.0-Beta.2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -o $@ $^


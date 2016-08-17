all:
	swift build

run:
	swift build
	.build/debug/version

xcode:
	swift package generate-xcodeproj
	open version.xcodeproj

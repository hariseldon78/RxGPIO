import PackageDescription

let package = Package(
	name: "RxGPIO",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 0)
		, .Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3)
		, .Package(url: "https://github.com/crossroadlabs/Regex.git", "1.0.0-alpha.1")
		//		, .Package(url: "https://github.com/PureSwift/SwiftFoundation", majorVersion: 2)
	]
)

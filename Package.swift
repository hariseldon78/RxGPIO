import PackageDescription

let package = Package(
	name: "RxGPIO",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 0)
		, .Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3)
	]
)

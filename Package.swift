// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "SubtitlesConverter",
	platforms: [.macOS(.v11)],
	products: [
		.executable(name: "SubtitlesConverter", targets: ["SubtitlesConverter"])
	],
	dependencies: [
		.package(name: "Tokamak", url: "https://github.com/TokamakUI/Tokamak", from: "0.6.1")
	],
	targets: [
		.target(
			name: "SubtitlesConverter",
			dependencies: [
				.product(name: "TokamakShim", package: "Tokamak"),
				.target(name: "Converters")
			]
		),
		.target(name: "Converters"),
		.testTarget(
			name: "SubtitlesConverterTests",
			dependencies: ["SubtitlesConverter"]
		),
		.testTarget(
			name: "ConvertersTests",
			dependencies: ["Converters"]
		)
	]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "SubtitlesConverter",
	platforms: [.macOS(.v11)],
	products: [
		.executable(name: "SubtitlesConverter", targets: ["SubtitlesConverter"])
	],
	dependencies: [
		.package(url: "https://github.com/TokamakUI/Tokamak", from: "0.6.1"),
		.package(url: "https://github.com/Cosmo/ISO8859", from: "1.1.0")
	],
	targets: [
		.target(
			name: "SubtitlesConverter",
			dependencies: [
				.product(name: "TokamakShim", package: "Tokamak"),
				.target(name: "Converters")
			]
		),
		.target(
			name: "Converters",
			dependencies: [
				.product(name: "ISO8859", package: "ISO8859")
			]
		),
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

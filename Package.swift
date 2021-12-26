// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "SubtitlesConverter",
	platforms: [.macOS(.v11)],
	products: [
		.executable(name: "SubtitlesConverter", targets: ["SubtitlesConverter"])
	],
	dependencies: [
		.package(url: "https://github.com/TokamakUI/Tokamak", .exact("0.9.0")),
		.package(url: "https://github.com/Cosmo/ISO8859", .exact("1.1.0")),
		.package(url: "https://github.com/revolter/DOMKit", .revision("88cf26"))
	],
	targets: [
		.target(
			name: "SubtitlesConverter",
			dependencies: [
				.product(name: "TokamakShim", package: "Tokamak"),
				.product(name: "DOMKit", package: "DOMKit"),
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

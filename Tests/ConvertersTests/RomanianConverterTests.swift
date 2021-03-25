//
//  RomanianConverterTests.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 15.03.2021.
//

import XCTest

import Converters

final class RomanianConverterTests: XCTestCase {
	static var allTests = [
		("testChangedDiacritics", testChangedDiacritics),
		("testUnchangedDiacritics", testUnchangedDiacritics),
		("testUnchangedContent", testUnchangedContent)
	]

	func testChangedDiacritics() throws {
		let original = "ãºþÃªÞ"
		let expected = "ășțĂȘȚ"

		let converted = try XCTUnwrap(RomanianConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testUnchangedDiacritics() {
		let original = "âîÂÎ"

		let converted = RomanianConverter.convert(original)

		XCTAssertNil(converted)
	}

	func testUnchangedContent() {
		let original = "English text"

		let converted = RomanianConverter.convert(original)

		XCTAssertNil(converted)
	}
}

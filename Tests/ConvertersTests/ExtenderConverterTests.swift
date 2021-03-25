//
//  ExtenderConverterTests.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 12.03.2021.
//

import XCTest

import Converters

final class ExtenderConverterTests: XCTestCase {
	static var allTests = [
		("testOverLimit", testOverLimit),
		("testUnderLimit", testUnderLimit),
		("testAlreadyOverLimit", testAlreadyOverLimit),
		("testMilliseconds", testMilliseconds),
		("testLinuxLineEndings", testLinuxLineEndings),
		("testWindowsLineEndings", testWindowsLineEndings),
		("testOldMacLineEndings", testOldMacLineEndings)
	]

	func testOverLimit() throws {
		let original =
			"""

			1
			00:00:01,000 --> 00:00:02,000
			Subtitle 1

			2
			00:00:15,000 --> 00:00:16,000
			Subtitle 2

			"""

		let expected =
			"""

			1
			00:00:01,000 --> 00:00:11,000
			Subtitle 1

			2
			00:00:15,000 --> 00:00:16,000
			Subtitle 2

			"""

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testUnderLimit() throws {
		let original =
			"""

			1
			00:00:01,111 --> 00:00:02,222
			Subtitle 1

			2
			00:00:03,333 --> 00:00:04,444
			Subtitle 2

			"""

		let expected =
			"""

			1
			00:00:01,111 --> 00:00:03,333
			Subtitle 1

			2
			00:00:03,333 --> 00:00:04,444
			Subtitle 2

			"""

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testAlreadyOverLimit() throws {
		let original =
			"""

			18
			00:00:00,000 --> 00:00:11,000
			Subtitle 1

			19
			00:00:12,000 --> 00:00:13,000
			Subtitle 2

			"""

		let expected =
			"""

			18
			00:00:00,000 --> 00:00:11,000
			Subtitle 1

			19
			00:00:12,000 --> 00:00:13,000
			Subtitle 2

			"""

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testMilliseconds() throws {
		let original =
			"""

			1
			00:00:01,111 --> 00:00:02,222
			Subtitle 1

			2
			00:00:15,333 --> 00:00:16,444
			Subtitle 2

			"""

		let expected =
			"""

			1
			00:00:01,111 --> 00:00:11,111
			Subtitle 1

			2
			00:00:15,333 --> 00:00:16,444
			Subtitle 2

			"""

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testLinuxLineEndings() throws {
		let original = "\n1\n00:00:01,111 --> 00:00:02,222\nSubtitle 1\n\n2\n00:00:15,333 --> 00:00:16,444\nSubtitle 2\n"
		let expected = "\n1\n00:00:01,111 --> 00:00:11,111\nSubtitle 1\n\n2\n00:00:15,333 --> 00:00:16,444\nSubtitle 2\n"

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testWindowsLineEndings() throws {
		// swiftlint:disable line_length
		let original = "\r\n1\r\n00:00:01,111 --> 00:00:02,222\r\nSubtitle 1\r\n\r\n2\r\n00:00:15,333 --> 00:00:16,444\r\nSubtitle 2\r\n"
		let expected = "\r\n1\r\n00:00:01,111 --> 00:00:11,111\r\nSubtitle 1\r\n\r\n2\r\n00:00:15,333 --> 00:00:16,444\r\nSubtitle 2\r\n"
		// swiftlint:enable line_length

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}

	func testOldMacLineEndings() throws {
		let original = "\r1\r00:00:01,111 --> 00:00:02,222\rSubtitle 1\r\r2\r00:00:15,333 --> 00:00:16,444\rSubtitle 2\r"
		let expected = "\r1\r00:00:01,111 --> 00:00:11,111\rSubtitle 1\r\r2\r00:00:15,333 --> 00:00:16,444\rSubtitle 2\r"

		let converted = try XCTUnwrap(ExtenderConverter.convert(original))

		XCTAssertEqual(converted, expected)
	}
}

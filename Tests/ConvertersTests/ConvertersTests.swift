//
//  ConvertersTests.swift
//
//
//  Created by Iulian Onofrei on 12.03.2021.
//

import XCTest

import Converters

final class ConvertersTests: XCTestCase {
	static var allTests = [
		("testExtenderOverLimit", testExtenderOverLimit),
		("testExtenderUnderLimit", testExtenderUnderLimit),
		("testExtenderMilliseconds", testExtenderMilliseconds)
	]

	func testExtenderOverLimit() throws {
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

	func testExtenderUnderLimit() throws {
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

	func testExtenderMilliseconds() throws {
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
}

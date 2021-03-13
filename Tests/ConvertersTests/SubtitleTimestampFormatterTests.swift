//
//  SubtitleTimestampFormatterTests.swift
//
//
//  Created by Iulian Onofrei on 13.03.2021.
//

import Foundation
import XCTest

@testable
import Converters

final class SubtitleTimestampFormatterTests: XCTestCase {
	static var allTests = [
		("test1", test1),
		("test2", test2),
		("test3", test3)
	]

	func test1() throws {
		let original = "00:00:00,010"
		let converted = try XCTUnwrap(original.getSubtitleTimestampDate()?.getSubtitleTimestampString())

		XCTAssertEqual(converted, original)
	}

	func test2() throws {
		let original = "00:00:00,001"
		let converted = try XCTUnwrap(original.getSubtitleTimestampDate()?.getSubtitleTimestampString())

		XCTAssertEqual(converted, original)
	}

	func test3() throws {
		let original = "00:00:00,100"
		let converted = try XCTUnwrap(original.getSubtitleTimestampDate()?.getSubtitleTimestampString())

		XCTAssertEqual(converted, original)
	}
}

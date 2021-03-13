//
//  XCTestManifests.swift
//
//
//  Created by Iulian Onofrei on 12.03.2021.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(ExtenderConvertersTests.allTests),
		testCase(SubtitleTimestampFormatterTests.allTests)
	]
}
#endif

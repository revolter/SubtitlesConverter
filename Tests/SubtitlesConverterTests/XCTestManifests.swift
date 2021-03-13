//
//  XCTestManifests.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 05.03.2021.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(SubtitlesConverterTests.allTests)
	]
}
#endif

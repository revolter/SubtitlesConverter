import XCTest

import SubtitlesConverterTests
import ConvertersTests

var tests = [XCTestCaseEntry]()
tests += SubtitlesConverterTests.allTests()
tests += ConvertersTests.allTests()

XCTMain(tests)

//
//  LinuxMain.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 13.03.2021.
//

import XCTest

import SubtitlesConverterTests
import ConvertersTests

var tests = [XCTestCaseEntry]()
tests += SubtitlesConverterTests.allTests()
tests += ConvertersTests.allTests()

XCTMain(tests)

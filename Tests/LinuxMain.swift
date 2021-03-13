//
//  LinuxMain.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 13.03.2021.
//

import XCTest

import ConvertersTests
import SubtitlesConverterTests

var tests = [XCTestCaseEntry]()

tests += SubtitlesConverterTests.allTests()
tests += ConvertersTests.allTests()

XCTMain(tests)

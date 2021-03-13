//
//  Extensions.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 09.03.2021.
//

import Foundation

extension String {
	func getSubtitleTimestampDate() -> Date? {
		return SubtitleTimestampFormatter.date(from: self)
	}
}

extension Date {
	func getSubtitleTimestampString() -> String? {
		return SubtitleTimestampFormatter.string(from: self)
	}
}

//
//  Extensions.swift
//  
//
//  Created by Iulian Onofrei on 09.03.2021.
//

import Foundation

extension DateFormatter {
	static var subtitleTimestampFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss,SSS"

		return formatter
	}()
}

extension String {
	func getSubtitleTimestampDate() -> Date? {
		return DateFormatter.subtitleTimestampFormatter.date(from: self)
	}
}

extension Date {
	func getSubtitleTimestampString() -> String? {
		return DateFormatter.subtitleTimestampFormatter.string(from: self)
	}
}

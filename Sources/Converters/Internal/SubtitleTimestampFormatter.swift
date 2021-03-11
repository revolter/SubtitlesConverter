//
//  SubtitleTimestampFormatter.swift
//  
//
//  Created by Iulian Onofrei on 10.03.2021.
//

import Foundation

struct SubtitleTimestampFormatter {
	private static let nanosecondsInMillisecond = 1_000_000

	private static let calendar = Calendar(identifier: .gregorian)

	private static let pattern = "(?<hour>\\d{2}):(?<minute>\\d{2}):(?<second>\\d{2}),(?<millisecond>\\d{3})"

	private static let regex = try? NSRegularExpression(pattern: Self.pattern, options: .anchorsMatchLines)

	// MARK: - Internal

	static func string(from date: Date) -> String? {
		let requiredComponents: Set<Calendar.Component> = [.hour, .minute, .second, .nanosecond]
		let components = self.calendar.dateComponents(requiredComponents, from: date)

		let hour = components.hour ?? 0
		let minute = components.minute ?? 0
		let second = components.second ?? 0
		let nanosecond = components.nanosecond ?? 0

		let millisecond = nanosecond / self.nanosecondsInMillisecond

		let padLength = 2
		let padText = "0"

		let paddedHour = String(hour).padding(toLength: padLength, withPad: padText, startingAt: 0)
		let paddedMinute = String(minute).padding(toLength: padLength, withPad: padText, startingAt: 0)
		let paddedSecond = String(second).padding(toLength: padLength, withPad: padText, startingAt: 0)
		let paddedMillisecond = String(millisecond).padding(toLength: 3, withPad: padText, startingAt: 0)

		return "\(paddedHour):\(paddedMinute):\(paddedSecond),\(paddedMillisecond)"
	}

	static func date(from string: String) -> Date? {
		guard let regex = Self.regex else {
			return nil
		}

		let range = NSRange(location: 0, length: string.utf8.count)

		guard let match = regex.firstMatch(in: string, range: range) else {
			return nil
		}

		let hourNSRange = match.range(withName: "hour")
		let minuteNSRange = match.range(withName: "minute")
		let secondNSRange = match.range(withName: "second")
		let millisecondNSRange = match.range(withName: "millisecond")

		guard
			let hourRange = Range(hourNSRange, in: string),
			let minuteRange = Range(minuteNSRange, in: string),
			let secondRange = Range(secondNSRange, in: string),
			let millisecondRange = Range(millisecondNSRange, in: string)
		else {
			return nil
		}

		let hourText = string[hourRange]
		let minuteText = string[minuteRange]
		let secondText = string[secondRange]
		let millisecondText = string[millisecondRange]

		let hour = Int(hourText) ?? 0
		let minute = Int(minuteText) ?? 0
		let second = Int(secondText) ?? 0
		let millisecond = Int(millisecondText) ?? 0

		let nanosecond = millisecond * self.nanosecondsInMillisecond

		let components = DateComponents(calendar: self.calendar, hour: hour, minute: minute, second: second, nanosecond: nanosecond)

		return self.calendar.date(from: components)
	}
}

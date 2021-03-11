//
//  ExtenderConverter.swift
//  
//
//  Created by Iulian Onofrei on 09.03.2021.
//

import Foundation

public struct ExtenderConverter {
	private static let maximumDuration: TimeInterval = 30

	private static let pattern = "(?<index>^\\d+$)\\n^(?<startTime>\\d\\d:[0-5]\\d:[0-5]\\d,\\d{1,3}) --> (?<endTime>\\d\\d:[0-5]\\d:[0-5]\\d,\\d{1,3})$\\n(?<text>(?:^.+$\\n?)+)"

	private static let regex = try? NSRegularExpression(pattern: Self.pattern, options: .anchorsMatchLines)

	// MARK: - Public

	public static func convert(_ content: String) -> String? {
		guard let regex = Self.regex else {
			return nil
		}

		var newContent = content

		let range = NSRange(location: 0, length: content.utf16.count)
		let matches = regex.matches(in: content, range: range)
		let reversedMatches = matches.enumerated().reversed()

		for (offset, match) in reversedMatches.dropLast() {
			let previousItem = reversedMatches[.init(reversedMatches.count - offset)]
			let previousMatch = previousItem.element

			let previousStartTimeNSRange = previousMatch.range(withName: "startTime")
			let previousEndTimeNSRange = previousMatch.range(withName: "endTime")
			let startTimeNSRange = match.range(withName: "startTime")

			guard
				let previousStartTimeRange = Range(previousStartTimeNSRange, in: newContent),
				let previousEndTimeRange = Range(previousEndTimeNSRange, in: newContent),
				let startTimeRange = Range(startTimeNSRange, in: newContent)
			else {
				continue
			}

			let previousStartTimestampString = String(newContent[previousStartTimeRange])
			let startTimestampString = String(newContent[startTimeRange])

			guard
				let previousStartTimestampDate = previousStartTimestampString.getSubtitleTimestampDate(),
				let startTimestampDate = startTimestampString.getSubtitleTimestampDate()
			else {
				continue
			}

			let deltaSeconds = startTimestampDate.timeIntervalSince(previousStartTimestampDate)
			var newEndTimestampString: String

			if deltaSeconds > Self.maximumDuration {
				let extraSeconds = deltaSeconds - Self.maximumDuration
				let newPreviousEndTimestampDate = startTimestampDate.addingTimeInterval(-extraSeconds)

				guard let timestampString = newPreviousEndTimestampDate.getSubtitleTimestampString() else {
					continue
				}

				newEndTimestampString = timestampString
			} else {
				newEndTimestampString = startTimestampString
			}

			newContent.replaceSubrange(previousEndTimeRange, with: newEndTimestampString)
		}

		return newContent
	}
}

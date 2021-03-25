//
//  ExtenderConverter.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 09.03.2021.
//

import Foundation

public enum ExtenderConverter {
	private static let maximumDuration: TimeInterval = 10

	// swiftlint:disable line_length
	private static let pattern =
		#"""
		(?<index>^\d+$)(?:\n|\r\n|\r)^(?<startTime>\d\d:[0-5]\d:[0-5]\d,\d{1,3})\x20-->\x20(?<endTime>\d\d:[0-5]\d:[0-5]\d,\d{1,3})$(?:\n|\r\n|\r)(?<text>(?:^.+$(?:\n|\r\n|\r)?)+)
		"""#
	// swiftlint:enable line_length

	private static let regex = try? NSRegularExpression(
		pattern: Self.pattern,
		options: [.anchorsMatchLines, .allowCommentsAndWhitespace]
	)

	// MARK: - Public

	// swiftlint:disable:next function_body_length
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
			let previousEndTimestampString = String(newContent[previousEndTimeRange])
			let startTimestampString = String(newContent[startTimeRange])

			guard
				let previousStartTimestampDate = previousStartTimestampString.getSubtitleTimestampDate(),
				let previousEndTimestampDate = previousEndTimestampString.getSubtitleTimestampDate(),
				let startTimestampDate = startTimestampString.getSubtitleTimestampDate()
			else {
				continue
			}

			let deltaSeconds = previousEndTimestampDate.timeIntervalSince(previousStartTimestampDate)
			let newDeltaSeconds = startTimestampDate.timeIntervalSince(previousStartTimestampDate)

			let isOverLimit = deltaSeconds > Self.maximumDuration
			let willBeOverLimit = newDeltaSeconds > Self.maximumDuration

			if isOverLimit {
				continue
			}

			var newEndTimestampString: String

			if willBeOverLimit {
				let extraSeconds = newDeltaSeconds - Self.maximumDuration
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

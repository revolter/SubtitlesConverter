//
//  ExtenderConverter.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 09.03.2021.
//

import Foundation

public enum ExtenderConverter {
	private static let maximumDuration: TimeInterval = 10

	private static let pattern =
		#"""
		(?<index>				# capture the index
			^\d+$				# matching an entire line composed of digits
		)

		(?:						# don't capture the EOL
			\n|\r\n|\r			# represented by one of the possible line endings
		)

		^						# match from the beginning of the line
			(?<startTime>		# capture the start time
				\d{2}:			# matching any 2 digits as the hour, and the `:` separator
				[0-5]\d:		# matching 2 digits, where the first one goes up to 5, as the minute, and the `:` separator
				[0-5]\d,		# matching 2 digits, where the first one goes up to 5, as the second, and the `,` separator
				\d{1,3}			# matching any 3 digits as the millisecond
			)
			\x20-->\x20			# followed by ` --> `
			(?<endTime>			# capture the end time
				\d{2}:			# matching any 2 digits as the hour, and the `:` separator
				[0-5]\d:		# matching 2 digits, where the first one goes up to 5, as the minute, and the `:` separator
				[0-5]\d,		# matching 2 digits, where the first one goes up to 5, as the second, and the `,` separator
				\d{1,3}			# matching any 3 digits as the millisecond
			)
		$						# matching to the end of the line

		(?:						# don't capture the EOL
			\n|\r\n|\r			# represented by one of the possible line endings
		)

		(?<text>				# capture the text
			(?:					# not capturing each line separately
				^.+$			# matching an entire line composed of any character
				(?:				# not capturing the EOL
					\n|\r\n|\r	# represented by one of the possible line endings
				)?				# appearing zero or more times
			)+					# appearing one or more times
		)
		"""#

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

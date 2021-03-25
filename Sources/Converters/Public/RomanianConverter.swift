//
//  RomanianConverter.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 14.03.2021.
//

import Foundation

import ISO8859

public enum RomanianConverter {
	// MARK: - Public

	public static func convert(_ content: String) -> String? {
		guard let contentData = content.data(using: .windowsCP1252) else {
			return nil
		}

		return String(contentData, iso8859Encoding: .part16)
	}
}

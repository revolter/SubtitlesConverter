//
//  JSFileReader.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 15.03.2021.
//

import JavaScriptKit

final class JSFileReader: JSBridgedClass {
	enum ReadyState: Int {
		case empty
		case loading
		case done
	}

	// swiftlint:disable:next force_unwrapping
	static let constructor = JSObject.global.FileReader.function!

	let jsObject: JSObject

	var readyState: ReadyState? {
		get {
			ReadyState(rawValue: Int(jsObject.readyState.number ?? 0))
		}
		set {
			// swiftlint:disable:next force_unwrapping
			_ = jsObject.setReadyState!(newValue?.rawValue)
		}
	}

	var result: String? {
		get {
			jsObject.result.string
		}
		set {
			// swiftlint:disable:next force_unwrapping
			_ = jsObject.setResult!(newValue)
		}
	}

	var onload: JSValue? {
		get {
			jsObject.onload
		}
		set {
			if let value = newValue {
				jsObject.onload = value
			}
		}
	}

	init() {
		jsObject = Self.constructor.new()
	}

	init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	func readAsText(blob: JSObject, encoding: String = "UTF-8") {
		// swiftlint:disable:next force_unwrapping
		_ = jsObject.readAsText!(blob, JSString(encoding))
	}
}

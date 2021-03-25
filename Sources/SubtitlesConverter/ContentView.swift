//
//  ContentView.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 13.03.2021.
//

import DOMKit
import JavaScriptKit
import TokamakDOM

import Converters

struct ContentView: View {
	static let inputId = "file"

	var document = JSObject.global.document

	var body: some View {
		VStack {
			HTML("input", [
				"id": Self.inputId,
				"type": "file"
			])
			Button("Extend") {
				var input = self.getInput()

				let jsFile = input.files.item(0)

				guard let file = File(from: jsFile) else {
					return
				}

				let jsPromise = file.text()

				jsPromise.then { content in
					guard let encodeURIComponent = JSObject.global.encodeURIComponent.function else {
						return
					}

					guard let newContent = ExtenderConverter.convert(content) else {
						return
					}

					let newContentEncoded = encodeURIComponent(newContent)
					let newBase64Content = "data:text/plain;charset=utf-16,\(newContentEncoded)"
					let newFileName = "converted_\(file.name)"

					let anchor = self.document.createElement("a")
					_ = anchor.setAttribute("href", newBase64Content)
					_ = anchor.setAttribute("download", newFileName)
					_ = anchor.click()

					input.value = ""

					// Without this, `jsPromise` gets released before this
					// closure gets called.
					print(jsPromise)
				}
			}
			Button("Romanian") {
				var input = self.getInput()
				let file = input.files.item(0)

				let fileReader = FileReader()

				fileReader.onload = { _ in
					guard fileReader.readyState == fileReader.DONE else {
						return .undefined
					}

					guard let result = fileReader.result else {
						return .undefined
					}

					guard case let .string(content) = result else {
						return .undefined
					}

					guard let encodeURIComponent = JSObject.global.encodeURIComponent.function else {
						return .undefined
					}

					guard let newContent = RomanianConverter.convert(content) else {
						return .undefined
					}

					let newContentEncoded = encodeURIComponent(newContent)
					let newBase64Content = "data:text/plain;charset=utf-16,\(newContentEncoded)"
					let newFileName = "converted_\(file.name)"

					let anchor = self.document.createElement("a")
					_ = anchor.setAttribute("href", newBase64Content)
					_ = anchor.setAttribute("download", newFileName)
					_ = anchor.click()

					input.value = ""

					return .undefined
				}

				guard let blob = Blob(from: file) else {
					return
				}

				fileReader.readAsText(blob: blob, encoding: "windows-1252")
			}
		}
	}

	func getInput() -> JSValue {
		return self.document.getElementById(Self.inputId)
	}
}

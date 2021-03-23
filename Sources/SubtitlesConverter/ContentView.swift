//
//  ContentView.swift
//  SubtitlesConverter
//
//  Created by Iulian Onofrei on 13.03.2021.
//

import JavaScriptKit
import TokamakDOM

import Converters

struct ContentView: View {
	@State var romanianFileLoadClosure: JSClosure?

	var body: some View {
		VStack {
			HTML("input", [
				"id": "file",
				"type": "file"
			])
			Button("Extend") {
				let document = JSObject.global.document
				var input = document.getElementById("file")

				guard let file = input.files.item(0).object else {
					return
				}

				guard let promise = file.text?().object else {
					return
				}

				guard let jsPromise = JSPromise<JSValue, Error>(promise) else {
					return
				}

				jsPromise.then { value in
					guard let encodeURIComponent = JSObject.global.encodeURIComponent.function else {
						return
					}

					guard let content = value.string else {
						return
					}

					guard let newContent = ExtenderConverter.convert(content) else {
						return
					}

					let newContentEncoded = encodeURIComponent(newContent)
					let newFile = "data:text/plain;charset=utf-16,\(newContentEncoded)"
					let newFileName = "converted_\(file.name)"

					let anchor = document.createElement("a")
					_ = anchor.setAttribute("href", newFile)
					_ = anchor.setAttribute("download", newFileName)
					_ = anchor.click()

					input.value = ""

					// Without this, `jsPromise` gets released before this
					// closure gets called.
					print(jsPromise)
				}
			}
			Button("Romanian") {
				let document = JSObject.global.document
				var input = document.getElementById("file")

				guard let file = input.files.item(0).object else {
					return
				}

				let fileReader = JSFileReader()

				let closure: ([JSValue]) -> Void = { _ in
					guard
						let state = fileReader.readyState,
						state == .done
					else {
						return
					}

					guard let content = fileReader.result else {
						return
					}

					guard let encodeURIComponent = JSObject.global.encodeURIComponent.function else {
						return
					}

					guard let newContent = RomanianConverter.convert(content) else {
						return
					}

					let newContentEncoded = encodeURIComponent(newContent)
					let newFile = "data:text/plain;charset=utf-16,\(newContentEncoded)"
					let newFileName = "converted_\(file.name)"

					let anchor = document.createElement("a")
					_ = anchor.setAttribute("href", newFile)
					_ = anchor.setAttribute("download", newFileName)
					_ = anchor.click()

					input.value = ""

					self.romanianFileLoadClosure?.release()
				}

				self.romanianFileLoadClosure = JSClosure(closure)

				if let listener = self.romanianFileLoadClosure {
					fileReader.onload = .object(listener)

					fileReader.readAsText(blob: file, encoding: "windows-1252")
				}
			}
		}
	}
}

import JavaScriptKit
import TokamakDOM

import Converters

struct TokamakApp: App {
	var body: some Scene {
		WindowGroup("Tokamak App") {
			ContentView()
		}
	}
}

struct ContentView: View {
	var body: some View {
		VStack {
			HTML("input", [
				"id": "file",
				"type": "file"
			])
			Button("Convert") {
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
		}
	}
}

// @main attribute is not supported in SwiftPM apps.
// See https://bugs.swift.org/browse/SR-12683 for more details.
TokamakApp.main()

import JavaScriptKit
import TokamakDOM

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
				let input = document.getElementById("file")

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

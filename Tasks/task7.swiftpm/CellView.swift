//
//  Cell.swift
//  task7
//
//  Created by Rex Feng on 3/4/23.
//

import SwiftUI

struct Cell: View {
    @State private var location = "" // location/key in GridData. ex: "A1"
    @ObservedObject private var data: GridData

    // `text` is a very basic text value. It does NOT differentiate between the formula used in the CellView and the displayed text label.
    // When the cell is deselected, the text value is crudely parsed and converted to the updated display text.
    // As such, there is no way to check for other cells which depend on this cell's value.
    @State var text = ""

    @FocusState private var textIsFocused: Bool

    init(location: String, mapping: GridData, text: String) {
        self.location = location
        self.data = mapping
        self.text = text
    }

    var body: some View {
        HStack {
            TextField("", text: $text)
                .padding()
                .focused($textIsFocused)
                .onChange(of: textIsFocused) { isFocused in
                    if (!isFocused) {
                        data.storeCellValue(key: location, value: text)
                        parseInput(input: text)
                    }
                }

            if textIsFocused {
                Button(action: acceptValue) {
                    Label("", systemImage: "checkmark.circle")
                }
            }
        }
        .frame(width: 180, height: 50)
        .background(textIsFocused ? .yellow : .white)
    }

    private func acceptValue() {
        textIsFocused = false
    }

    // parseInput() is a VERY basic cell text parser and processor. Do not expect most spreadsheet cell functions here
    private func parseInput(input: String) {
        // if text starts with "=", then parse, else do not parse
        guard input.hasPrefix("=") else { return }

        // remove first letter ("=")
        var inputText = String(input.dropFirst())

        let gridKeys = data.getAllKeys()
        // note: it is not efficient to iterate through all keys (A1, A2, ..., Z99)
        for key in gridKeys {
            if (key != location && inputText.contains(key)) {
                if let value = data.getCellValue(key: key) {
                    // replace occurrences of key with key's text value
                    inputText = inputText.replacingOccurrences(of: key, with: value)
                }
            }
        }

        // very naive equation resolving
        if (inputText.contains("+") || inputText.contains("-") || inputText.contains("*") || inputText.contains("/")) {
            let expression = NSExpression(format: inputText)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                inputText = String(result)
            }
        }

        data.storeCellValue(key: location, value: inputText)
        text = inputText
    }

}

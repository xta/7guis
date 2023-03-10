//
//  Cell.swift
//  task7
//
//  Created by Rex Feng on 3/4/23.
//

import SwiftUI

struct Cell: View, Hashable, Identifiable {
    @State private var location = "" // unique location/key in GridData. ex: "A1"

    @ObservedObject private var inputData: GridData
    @ObservedObject private var displayData: GridData

    // these String values get their value from their GridData source
    var input: String { inputData.data[location] ?? "" }
    var display: String { displayData.data[location] ?? "" }

    // $fieldText is used for the TextField()
    @State var fieldText: String = ""

    @FocusState private var textIsFocused: Bool

    init(location: String, inputData: GridData, displayData: GridData) {
        self.location = location
        self.inputData = inputData
        self.displayData = displayData
    }

    // Identifiable
    var id: String { location }

    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(location) }

    // Equatable
    static func ==(lhs: Cell, rhs: Cell) -> Bool { lhs.location == rhs.location }

    var body: some View {
        HStack {
            TextField("", text: $fieldText)
                .padding()
                .focused($textIsFocused)
                .onChange(of: textIsFocused) { isFocused in
                    if (!isFocused) {
                        // field is unselected, switch to display value

                        // store $fieldText value in inputData
                        inputData.storeCellValue(key: location, value: fieldText)

                        // optionally parse the input
                        parseInput(input: fieldText)

                        // switch $fieldText to display version
                        fieldText = display
                    } else {
                        // field is selected, switch to input value

                        // switch $fieldText to input version
                        fieldText = input
                    }
                }

            if textIsFocused {
                Button(action: acceptValue) {
                    Label("", systemImage: "checkmark.circle")
                }
            }
        }
        .onAppear {
            // setup init values
            self.location = location
            self.fieldText = display
        }
        .frame(width: 180, height: 50)
        .background(textIsFocused ? .yellow : .white)
    }

    private func acceptValue() {
        textIsFocused = false
    }

    // parseInput() is a VERY basic cell text parser and processor. Do not expect most spreadsheet cell functions here
    private func parseInput(input: String) {
        // only parse if text starts with "="
        guard input.hasPrefix("=") else {
            // store our unmodified display text
            displayData.storeCellValue(key: location, value: input)
            return
        }

        // remove first letter ("=")
        var inputText = String(input.dropFirst())

        let gridKeys = inputData.getAllKeys()
        // note: it is not efficient to iterate through all keys (A1, A2, ..., Z99)
        for key in gridKeys {
            if (key != location && inputText.contains(key)) {
                // lookup external (display) value of target Cell
                if let value = displayData.getCellValue(key: key) {
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

        // store our modified display text
        displayData.storeCellValue(key: location, value: inputText)
    }

}

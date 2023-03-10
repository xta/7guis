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
    @State private var editMode = false

    var inputValueDidUpdate: (String, String) -> Void

    init(location: String, inputData: GridData, displayData: GridData, callback: @escaping (String, String) -> Void) {
        self.location = location
        self.inputData = inputData
        self.displayData = displayData
        self.inputValueDidUpdate = callback
    }

    // Identifiable
    var id: String { location }

    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(location) }

    // Equatable
    static func ==(lhs: Cell, rhs: Cell) -> Bool { lhs.location == rhs.location }

    var body: some View {
        HStack {
            if editMode {
                TextField("", text: $fieldText)
                    .padding()
                    .focused($textIsFocused)
                    .onChange(of: textIsFocused) { isFocused in
                        if (!isFocused) {
                            // field is unselected, switch to display value

                            // store $fieldText value in inputData
                            inputData.storeCellValue(key: location, value: fieldText)

                            // optionally parse the input
                            self.inputValueDidUpdate(location, fieldText)

                            // switch $fieldText to display version
                            fieldText = display
                        } else {
                            // field is selected, switch to input value

                            // switch $fieldText to input version
                            fieldText = input
                        }
                    }
            } else {
                Text(display)
            }

            if editMode {
                Button(action: hideField) {
                    Label("", systemImage: "checkmark.circle")
                }
            } else {
                // Instead of using this edit button, I'd rather not include it.
                // However, I need to show the display text above. And cannot rely on `fieldText = display` to run above when `display` value changes
                Button(action: showField) {
                    Label("", systemImage: "square.and.pencil")
                        .foregroundColor(.gray)
                        .opacity(0.4)
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

    private func showField() {
        textIsFocused = true
        editMode = true
    }

    private func hideField() {
        textIsFocused = false

        // there has to be a better way to do this... need to trigger the TextField() .onChange event first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            editMode = false
        }

    }

}

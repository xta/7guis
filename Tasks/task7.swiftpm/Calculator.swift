//
//  Calculator.swift
//  task7
//
//  Created by Rex Feng on 3/10/23.
//

import SwiftUI

class Calculator {

    @ObservedObject private var inputData: GridData
    @ObservedObject private var displayData: GridData

    init(inputData: GridData, displayData: GridData) {
        self.inputData = inputData
        self.displayData = displayData
    }

    func cellValueUpdated(location: String, input: String, references: inout [String: [String]]) {
        parseInput(location: location, input: input, references: &references)

        handleAnyDependencies(location: location, references: &references)
    }

    // parseInput() is a VERY basic cell text parser and processor. Do not expect most spreadsheet cell functions here
    private func parseInput(location: String, input: String, references: inout [String: [String]]) {
        removeCellFromAllReferences(location: location, references: &references)

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
                addCellToReference(location: location, target: key, references: &references)

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

    // handleAnyDependencies() is a very basic dependency resolver
    // it checks `references` once. it will not try to resolve many references back and forth between cells
    private func handleAnyDependencies(location: String, references: inout [String: [String]]) {
        if let value = references[location] {
            for key in value {
                if let input = inputData.getCellValue(key: key) {
                    parseInput(location: key, input: input, references: &references)
                }
            }
        }
    }

    // when adding cell to reference, this means this location relies on the target
    // so if this cell is A2, the value contains a reference to the target (A1): "=A1"
    // references will have ["A1": ["A2"]]. A2 relies on A1's value
    private func addCellToReference(location: String, target: String, references: inout [String: [String]]) {
        if references[target] != nil {
            references[target]?.append(location)
        } else {
            references[target] = [location]
        }
    }

    // removeCellFromAllReferences will iterate through references. this is not efficient
    private func removeCellFromAllReferences(location: String, references: inout [String: [String]]) {
        for (key, value) in references {
            if value.firstIndex(of: location) != nil {
                references[key] = references[key]?.filter{ $0 != location }
            }
        }
    }

}

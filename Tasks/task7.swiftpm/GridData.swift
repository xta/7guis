//
//  GridData.swift
//  task7
//
//  Created by Rex Feng on 3/4/23.
//

import SwiftUI

// GridData is the canonical data store for CellView text values
class GridData: ObservableObject {
  
    @Published var data: [String:String]

    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    init() {
        data = [:]

        for letter in alphabet {
            for number in 1..<100 {
                let key = "\(letter)\(number)"
                self.data[key] = ""
            }
        }
    }

    func storeCellValue(key: String, value: String) {
        data[key] = value
    }

    func getCellValue(key: String) -> String? {
        if let text = data[key] {
            return text
        }
        return nil
    }

    func getAllKeys() -> [String] {
        return Array(data.keys)
    }

    // a column is A1, B1, ..., Y1, Z1
    func getColumnKeys(row: Int) -> [String] {
        return alphabet.map { "\($0)\(row)" }
    }

}

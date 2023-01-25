//
//  DateStringWrapper.swift
//  task3
//
//  Created by Rex Feng on 11/8/22.
//

import Foundation

class DateStringWrapper {
    let raw: String
    let day, month, year: Int
    let valid: Bool

    init(date: String) {
        self.raw = date

        let parts = raw.components(separatedBy: ".")

        if (parts.count == 3) {
            let first = parts[0]
            let second = parts[1]
            let third = parts[2]

            if (first.count == 2 && second.count == 2 && third.count == 4) {
                if let d = Int(first), let m = Int(second), let y = Int(third) {
                    // note: checking d, m, and y this way is not flawless. it is sufficient for this simple GUI exercise
                    if (d >= 1 && d <= 31 && m >= 1 && m <= 12 && y >= 0 && y <= 9999) {
                        self.day = d
                        self.month = m
                        self.year = y
                        self.valid = true
                    } else {
                        // TODO: DRY these 4 lines of code:
                        self.day = 0
                        self.month = 0
                        self.year = 0
                        self.valid = false
                    }
                } else {
                    self.day = 0
                    self.month = 0
                    self.year = 0
                    self.valid = false
                }
            } else {
                self.day = 0
                self.month = 0
                self.year = 0
                self.valid = false
            }
        } else {
            self.day = 0
            self.month = 0
            self.year = 0
            self.valid = false
        }
    }

}

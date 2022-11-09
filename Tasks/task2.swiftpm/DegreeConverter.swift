//
//  DegreeConverter.swift
//  task2
//
//  Created by Rex Feng on 11/8/22.
//

import Foundation

class DegreeConverter {

    let doubleFormat = "%.1f"

    // TODO: add unit tests for DegreeConverter. I tried to set it up, but setup for a [Swift Playgrounds App] needs more investigation.

    func getFahrenheit(celsius: String) -> String {
        if let c = Double(celsius) {
            let f = _getFahrenheit(celsius: c)
            return String(format: doubleFormat, f)
        }
        // else
        return ""
    }

    private func _getFahrenheit(celsius: Double) -> Double {
        return celsius * 9 / 5 + 32
    }

    func getCelsius(fahrenheit: String) -> String {
        if let f = Double(fahrenheit) {
            let c = _getCelsius(fahrenheit: f)
            return String(format: doubleFormat, c)
        }
        // else
        return ""
    }

    private func _getCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }

}

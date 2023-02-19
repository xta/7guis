//
//  Person.swift
//  task5
//
//  Created by Rex Feng on 1/29/23.
//

import SwiftUI

struct Person: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var lastName: String
}

// A view that shows the data for one Person
struct PersonRow: View {
    var person: Person

    var body: some View {
        Text("\(person.name) \(person.lastName)")
    }
}

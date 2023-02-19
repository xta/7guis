import SwiftUI

struct ContentView: View {

    @State private var prefixFilter = ""

    @State private var inputName = ""
    @State private var inputSurname = ""

    @State private var people = [
        Person(name: "Andy", lastName: "Zoo"),
        Person(name: "Betty", lastName: "Yoo"),
        Person(name: "Cho", lastName: "Xi"),
    ]

    @State private var selection: Person?

    var body: some View {
        HStack {

            VStack {
                Text("People")

                List(displayList) {
                    SelectionCell(person: $0, selected: self.$selection)
                }

                Text("Search for name")
                TextField(
                    "Name",
                    text: $prefixFilter
                )
            }

            VStack {
                Text("Name")
                TextField(
                    "Enter Name",
                    text: $inputName
                )
                Text("Surname")
                TextField(
                    "Enter Surname",
                    text: $inputSurname
                )

                Button("Create") {
                    createPerson()
                }

                Button("Update") {
                    updatePerson()
                }
                .disabled(!selectionIsSelected)

                Button("Delete") {
                    deletePerson()
                }
                .disabled(!selectionIsSelected)
            }
        }
    }

    var selectionIsSelected: Bool {
        return selection != nil
    }

    var displayList: [Person] {
        if (prefixFilter == "") {
            return people
        }

        return people.filter {
            $0.name.hasPrefix(prefixFilter)
        }
    }

    func createPerson() {
        if (!inputName.isEmpty && !inputSurname.isEmpty) {
            let person = Person(name: inputName, lastName: inputSurname)
            people.append(person)

            inputName = ""
            inputSurname = ""
        }
    }

    func updatePerson() {
        guard let person = selection else { return }

        if let index = people.firstIndex(where: { $0.id == person.id }) {
            let person = Person(name: inputName, lastName: inputSurname)
            people[index] = person

            inputName = ""
            inputSurname = ""
        }
    }

    func deletePerson() {
        guard let person = selection else { return }

        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people.remove(at: index)

            selection = nil
        }
    }
}

struct SelectionCell: View {
    let person: Person
    @Binding var selected: Person?

    var body: some View {
        HStack {
            PersonRow(person: person)
            Spacer()
            if person == selected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if (person == selected) {
                selected = nil
            } else {
                selected = person
            }
        }
    }
}

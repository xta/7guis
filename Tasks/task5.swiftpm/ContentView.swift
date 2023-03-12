import SwiftUI

struct ContentView: View {

    @State private var prefixFilter = ""

    @State private var inputName = ""
    @State private var inputSurname = ""

    // temp names handle edge case where user selects a person in the list after they entered a new person
    @State private var tempInputName = ""
    @State private var tempInputSurname = ""

    @State private var people = [
        Person(name: "Andy", lastName: "Zoo"),
        Person(name: "Betty", lastName: "Yoo"),
        Person(name: "Cho", lastName: "Xi"),
    ]

    @State private var selection: Person?

    var body: some View {
        VStack {
            Text("People")
            List(displayList) {
                SelectionCell(person: $0, selected: self.$selection)

            }
            .onChange(of: selection) { person in
                if let person = person {
                    tempInputName = inputName
                    tempInputSurname = inputSurname

                    inputName = person.name
                    inputSurname = person.lastName
                } else {
                    inputName = tempInputName
                    inputSurname = tempInputSurname
                }
            }

            VStack {
                if (selection != nil) {
                    Text("Edit person")
                } else {
                    Text("Add person")
                }

                HStack {
                    Text("Name")
                        .foregroundColor(.secondary)
                    TextField(
                        "Enter Name",
                        text: $inputName
                    )
                }
                HStack {
                    Text("Surname")
                        .foregroundColor(.secondary)
                    TextField(
                        "Enter Surname",
                        text: $inputSurname
                    )
                }
                HStack {
                    if (selection != nil) {
                        Button("Update") {
                            updatePerson()
                        }
                        .disabled(!selectionIsSelected)

                        Spacer()
                            .frame(width: 20)

                        Button("Delete") {
                            deletePerson()
                        }
                        .disabled(!selectionIsSelected)
                    } else {
                        Button("Create") {
                            createPerson()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!inputIsEntered)
                    }
                }
            }
            .padding([.leading, .trailing], 50)
            .padding([.top, .bottom], 10)

            Divider()

            VStack {
                Text("Search for name")
                TextField(
                    "First name",
                    text: $prefixFilter
                )
            }
            .padding([.leading, .trailing], 50)
            .padding([.top, .bottom], 10)
        }
    }

    var inputIsEntered: Bool {
        return inputName != "" && inputSurname != ""
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

            selection = nil
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

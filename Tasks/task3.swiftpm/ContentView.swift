import SwiftUI

struct ContentView: View {
    @State private var returnOn = false
    @State private var fromString = ""
    @State private var toString = ""

    @State private var fromDate = DateStringWrapper(date: "")
    @State private var toDate = DateStringWrapper(date: "")
    @State private var bookButtonEnabled = false

    @State private var fromBackground: Color = .white
    @State private var toBackground: Color = .white

    @State private var showConfirmation = false
    @State private var confirmationMessage = ""

    var body: some View {
        VStack {
            Text("Flight Booker")
                .font(.largeTitle)
                .padding(.bottom)

            VStack {
                Text("One way or return")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                Toggle(isOn: $returnOn) {
                    Text("Round trip?")
                }
            }
            .padding(.bottom)

            VStack {
                Text("Departing flight")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                TextField("Enter date (DD.MM.YYYY)",
                          text: $fromString)
                .background(fromBackground)
                .onChange(of: fromString) { newValue in
                    fromDate = DateStringWrapper(date: fromString)
                    self.updateState()
                }
            }
            .padding(.bottom)

            VStack {
                Text("Return flight")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                TextField("Enter date (DD.MM.YYYY)",
                          text: $toString)
                .foregroundColor(returnOn ? .black : .gray)
                .background(toBackground)
                .onChange(of: toString) { newValue in
                    toDate = DateStringWrapper(date: toString)
                    self.updateState()
                }
                .disabled(!returnOn)

            }
            .padding(.bottom)

            Button("Book", action: {
                let direction = returnOn ? "round trip" : "one-way"
                confirmationMessage = "You have booked a \(direction) flight on \(fromString)."

                showConfirmation = true
            })
                .buttonStyle(.borderedProminent)
                .disabled(!bookButtonEnabled)

            if (showConfirmation) {
                Text(confirmationMessage)
            }
        }
        .frame(maxWidth: 200)
        .onAppear() {
            let todayString = self.getTodayDateString()
            fromString = todayString
            toString = todayString

            fromDate = DateStringWrapper(date: fromString)
            toDate = DateStringWrapper(date: toString)
        }

    }

    func getTodayDateString() -> String {
        let date = Date()
        let calendar = Calendar.current
        let d = calendar.component(.day, from: date)
        let m = calendar.component(.month, from: date)
        let yyyy = calendar.component(.year, from: date)

        let dd = String(format: "%02d", d)
        let mm = String(format: "%02d", m)
        return "\(dd).\(mm).\(yyyy)"
    }

    func updateState() {
        showConfirmation = false

        if (returnOn) {
            // round trip

            if (fromDate.valid && toDate.valid) {

                // check if fromDate <= toDate
                if (fromDate.year < toDate.year) {
                    bookButtonEnabled = true
                } else if (fromDate.year == toDate.year) {
                    if (fromDate.month < toDate.month) {
                        bookButtonEnabled = true
                    } else if (fromDate.month == toDate.month) {
                        // same month, make sure from <= to
                        bookButtonEnabled = fromDate.day <= toDate.day
                    } else {
                        // to month is before from month
                        bookButtonEnabled = false
                    }
                } else {
                    // to year is before from year
                    bookButtonEnabled = false
                }

                fromBackground = .white
                toBackground = .white

            } else {
                // some or all of the dates are not valid
                bookButtonEnabled = false

                if (fromDate.valid) {
                    fromBackground = .white
                } else {
                    fromBackground = .red
                }

                if (toDate.valid) {
                    toBackground = .white
                } else {
                    toBackground = .red
                }

            }
        } else {
            // one way
            bookButtonEnabled = fromDate.valid

            if (fromDate.valid) {
                fromBackground = .white
            } else {
                fromBackground = .red
            }
        }
    }
}

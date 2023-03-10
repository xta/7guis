import SwiftUI

struct ContentView: View {
    // note: this is a prototype and not optimized for performance

    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    private let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)

    // inputData is the internal text value of the Cell
    @StateObject private var inputData = GridData()

    // displayData is the external text value of the Cell
    @StateObject private var displayData = GridData()

    @State private var columns: [Int: [Cell]] = [:]

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Text("Cells")

                ScrollView(.vertical) {
                    ScrollView(.horizontal) {
                        Grid() {

                            GridRow {
                                Color.clear
                                    .gridCellUnsizedAxes([.horizontal, .vertical])

                                // A-Z column header
                                ForEach(alphabet, id: \.self) { letter in
                                    Text("\(letter)")
                                        .background(backgroundColor)
                                }
                            }

                            // 100 rows (1-99)
                            ForEach(1..<100) { index in
                                GridRow {
                                    // 0-9 row header
                                    Text("\(index)")
                                        .background(backgroundColor)

                                    if let column = columns[index] {
                                        ForEach(column) { cell in
                                            cell
                                        }
                                    }
                                }

                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                setupColumns()
            }
            .background(backgroundColor)
        } else {
            Text("Requires iOS 16 or above")
        }
    }

    private func setupColumns() {
        // columns 1 - 99. each prefixed with A - Z.
        // a row is A1, B1, ..., Y1, Z1

        for number in 1..<100 {
            let keys = inputData.getColumnKeys(row: number)
            var column: [Cell] = []
            for key in keys {
                let cell = Cell(location: key, inputData: inputData, displayData: displayData)
                column.append(cell)
            }
            columns[number] = column
        }
    }

}

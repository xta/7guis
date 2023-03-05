import SwiftUI

struct ContentView: View {
    // note: this is a prototype and not optimized for performance

    // A - Z columns
    // 0 - 99 rows

    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    private let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)

    @StateObject private var data = GridData()

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

                                ForEach(alphabet, id: \.self) { letter in
                                    Text("\(letter)")
                                        .background(backgroundColor)
                                }
                            }

                            ForEach(1..<100) { index in
                                GridRow {
                                    Text("\(index)")
                                        .background(backgroundColor)

                                    ForEach(alphabet, id: \.self) { letter in
                                        let key = "\(letter)\(index)"
                                        if let value = data.getCellValue(key: key) {
                                            Cell(location: key, mapping: data, text: value)
                                        }
                                    }
                                }

                            }
                        }
                        .padding()
                    }
                }
            }
            .background(backgroundColor)
        } else {
            Text("Requires iOS 16 or above")
        }
    }

}

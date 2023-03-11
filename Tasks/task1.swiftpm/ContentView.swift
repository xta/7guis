import SwiftUI

struct ContentView: View {
    @State private var value = 0

    var body: some View {
        VStack {
            Text("Counter")
                .padding(.bottom)

            HStack {
                Text("\(value)")

                Button {
                    value += 1
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
}

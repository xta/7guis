import SwiftUI

struct ContentView: View {
    @State private var value = 0

    var body: some View {
        VStack {
            Text("Counter")
                .font(.title)
                .padding(.bottom)

            HStack {
                Text("\(value)")
                Button("Count", action: {
                    value += 1
                })
            }
        }
    }
}

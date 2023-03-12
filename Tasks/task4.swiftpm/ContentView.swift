import SwiftUI

struct ContentView: View {

    // current time that is incremented
    @State private var timeElapsed: Double = 0

    // timer length controlled by slider
    @State private var timerLength: Double = 30 // default

    // max length (seconds) of slider
    private let timerMax: Double = 180

    private let timerInterval: Double = 0.1
    let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                Text("Timer")
                    .font(.headline)
                Spacer()
                Button("Reset", action: {
                    timeElapsed = 0
                })
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom)

            ProgressView("Elapsed Time", value: timeElapsed, total: timerLength)
                .onReceive(tick) { _ in
                    if (timeElapsed < timerLength) {
                        timeElapsed += timerInterval
                    } else {
                        timeElapsed = timerLength
                    }
                }
            let label = timeElapsed > 1.0 ? "seconds" : "second"
            Text("\(timeElapsed, specifier: "%0.1f") \(label) elapsed")
                .padding(.bottom, 50)

            HStack {
                Text("Select Timer Length")
                    .font(.subheadline)
                Spacer()
                let label = timerLength > 1.0 ? "seconds" : "second"
                Text("\(timerLength, specifier: "%1.f") \(label)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .padding([.leading, .trailing])

            Slider(value: $timerLength, in: 1...timerMax, step: 1)
                .padding([.leading, .trailing])
        }
        .padding(50)
    }
}

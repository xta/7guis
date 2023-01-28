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
            Text("Timer")

            ProgressView("Elapsed Time", value: timeElapsed, total: timerLength)
                .onReceive(tick) { _ in
                    if (timeElapsed < timerLength) {
                        timeElapsed += timerInterval
                    } else {
                        timeElapsed = timerLength
                    }
                }

            Text("\(timeElapsed, specifier: "%0.1f") seconds elapsed")
                .padding(.bottom)

            Text("Select Timer Length")
            Slider(value: $timerLength, in: 1...timerMax, step: 1)

            Text("\(timerLength, specifier: "%1.f") seconds total")

            Button("Reset", action: {
                timeElapsed = 0
            })
            .buttonStyle(.borderedProminent)

        }
        .padding(20)
    }
}

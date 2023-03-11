import SwiftUI

struct ContentView: View {
    @State private var celsius: String = ""
    @State private var fahrenheit: String = ""

    var body: some View {
        VStack {
            Text("Temperature Converter")
                .font(.headline)
                .padding(.bottom)

            VStack(alignment: .leading) {
                HStack {
                    TextField("Enter degrees",
                              text: $celsius,
                              onEditingChanged: { (_) in
                        fahrenheit = DegreeConverter().getFahrenheit(celsius: celsius)
                    })
                    .textFieldStyle(.roundedBorder)
                    Text("° Celsius")
                }
                .fixedSize(horizontal: true, vertical: false)
                HStack {
                    Text("=")
                        .padding(.leading, 12)
                }
                HStack {
                    TextField("Enter degrees",
                              text: $fahrenheit,
                              onEditingChanged: { (_) in
                        celsius = DegreeConverter().getCelsius(fahrenheit: fahrenheit)
                    })
                    .textFieldStyle(.roundedBorder)
                    Text("° Fahrenheit")
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}

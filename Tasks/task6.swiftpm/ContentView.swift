import SwiftUI

struct ContentView: View {

    @State private var rounds: [Round] = []
    @State private var selectedID: UUID? = nil
    @State private var sliderValue: Double = 50

    @State private var userIsMovingSlider = false

    @State private var history: [History] = [History(withRounds: [], selected: nil, slider: 50)]
    @State private var currentIndex: Int? = nil

    var body: some View {
        if #available(iOS 16.0, *) {

            VStack {
                Text("Circle Draw")

                HStack {
                    Button("Undo") { undoHistory() }
                        .disabled( !canUndo() )
                    Button("Redo") { redoHistory() }
                        .disabled( !canRedo() )
                }

                ZStack {
                    Spacer()

                    ForEach(rounds) { round in
                        Circle().fill( round.isSelected(selectedID: selectedID) ? Color.blue : Color.white)
                            .frame(width: round.length, height: round.length)
                            .position(round.coord)
                    }
                }
                .background(Color.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    location in
                    handleTap(location)
                }

                VStack {
                    Text("Adjust diameter of selected circle")
                        .padding(.top)
                    Slider(
                        value: $sliderValue,
                        in: 10.0...100.0,
                        step: 2,
                        onEditingChanged: { editing in
                            userIsMovingSlider = editing
                        }
                    )
                    .animation(.easeInOut, value: sliderValue)
                    .onChange(of: sliderValue, perform: sliderChanged)
                    .disabled(selectedID == nil)
                }
                .padding()
                .opacity(selectedID == nil ? 0.5 : 1.0)
            }

        } else {
            Text("Requires iOS 16 or above")
        }
    }

    private func canUndo() -> Bool {
        guard let position = currentIndex else { return false }

        // ok to undo if there is more than 1 item in `history` and we are not at position 0 (first)
        return history.count > 1 && position > 0
    }

    private func canRedo() -> Bool {
        guard let position = currentIndex else { return false }

        // ok to redo if there is more than 1 item in `history` and we are not at last position
        return history.count > 1 && position < (history.count-1)
    }

    private func undoHistory() {
        if (canUndo()) {
            guard let current = currentIndex else { return }

            currentIndex = current - 1

            let item = history[current - 1]

            rounds = item.rounds
            selectedID = item.selectedID
            sliderValue = item.sliderValue
        }
    }

    private func redoHistory() {
        if (canRedo()) {
            guard let current = currentIndex else { return }

            currentIndex = current + 1

            let item = history[current + 1]

            rounds = item.rounds
            selectedID = item.selectedID
            sliderValue = item.sliderValue
        }
    }

    private func sliderChanged(to newValue: Double) {
        let value = CGFloat(newValue)
        adjustDiameter(newValue: value)
    }

    private func adjustDiameter(newValue: CGFloat) {
        if let id = selectedID {
            // brute force method to check each round
            for (index, element) in rounds.enumerated() {
                if (element.id == id) {
                    // update selected round's diameter
                    rounds[index].length = newValue

                    if (userIsMovingSlider) {
                        saveState()
                    }
                }
            }
        }
    }

    private func handleTap(_ point: CGPoint) {
        let defaultLength: CGFloat = 50

        var intersectingRound: Int? = nil

        // brute force method to check each round
        for (index, element) in rounds.enumerated() {
            if (checkOverlap(aCenter: point, aSize: defaultLength, bCenter: element.coord, bSize: element.length)) {
                intersectingRound = index
            }
        }

        if let index = intersectingRound {
            // overlap found

            if let selection = selectedID {
                // existing selection
                // toggle selection state for selected

                if (selection == rounds[index].id) {
                    // unselect overlap
                    selectedID = nil
                } else {
                    // replace existing selection with overlap found
                    selectedID = rounds[index].id
                    sliderValue = Double(rounds[index].length)
                }

            } else {
                // no existing selection
                selectedID = rounds[index].id
                sliderValue = Double(rounds[index].length)
            }

        } else {
            createNewRound(location: point)
        }
    }

    private func createNewRound(location: CGPoint) {
        let round = Round(location: location)
        rounds.append(round)
        selectedID = nil

        saveState()
    }

    private func saveState() {
        let current = History(withRounds: rounds, selected: selectedID, slider: sliderValue)

        if let current = currentIndex {
            // if currentIndex is not last position, then remove the future redo history
            if (current != history.count - 1) {
                history.removeSubrange(current+1..<history.count)
            }
        }

        history.append(current)
        currentIndex = history.count - 1
    }

    private func checkOverlap(aCenter: CGPoint, aSize: CGFloat, bCenter: CGPoint, bSize: CGFloat) -> Bool {
        let boxA = CGRect(origin: aCenter, size: CGSize(width: aSize, height: aSize))
        let boxB = CGRect(origin: bCenter, size: CGSize(width: bSize, height: bSize))
        return boxA.intersects(boxB)
    }

}

struct Round: Identifiable {
    let id = UUID()
    var coord = CGPointZero
    var selected = false
    var length: CGFloat = 50

    init(location: CGPoint) {
        coord = location
    }

    func isSelected(selectedID: UUID?) -> Bool {
        if let selectedID = selectedID {
            return selectedID == id
        }
        return false
    }
}

struct History {
    var rounds: [Round] = []
    var selectedID: UUID? = nil
    var sliderValue: Double = 50

    init(withRounds: [Round], selected: UUID?, slider: Double) {
        rounds = withRounds
        selectedID = selected
        sliderValue = slider
    }
}

import Foundation

final class GameModel {
    struct State {
        var round: Int
        var userScore: Int
        var pcScore: Int
        var userCard: PlayingCard?
        var pcCard: PlayingCard?
        var isFlipped: Bool
        var isGameOver: Bool
    }

    private(set) var state = State(round: 1, userScore: 0, pcScore: 0, userCard: nil, pcCard: nil, isFlipped: false, isGameOver: false)

    let maxRounds = 10

    private let deck: [PlayingCard] = [
        PlayingCard(imageName: "2", value: 2),
        PlayingCard(imageName: "3", value: 3),
        PlayingCard(imageName: "4", value: 4),
        PlayingCard(imageName: "5", value: 5),
        PlayingCard(imageName: "6", value: 6),
        PlayingCard(imageName: "7", value: 7),
        PlayingCard(imageName: "8", value: 8),
        PlayingCard(imageName: "9", value: 9),
        PlayingCard(imageName: "10", value: 10),
        PlayingCard(imageName: "prince", value: 11),
        PlayingCard(imageName: "queen", value: 12),
        PlayingCard(imageName: "king", value: 13),
        PlayingCard(imageName: "as", value: 14)
    ]

    var onStateChange: ((State) -> Void)?

    func reset() {
        state = State(round: 1, userScore: 0, pcScore: 0, userCard: nil, pcCard: nil, isFlipped: false, isGameOver: false)
        onStateChange?(state)
    }

    func drawAndScore() {
        guard !state.isGameOver else { return }
        let user = deck.randomElement()
        let pc = deck.randomElement()
        state.userCard = user
        state.pcCard = pc
        state.isFlipped = true
        if let u = user, let p = pc {
            if u.value > p.value {
                state.userScore += 1
            } else if p.value >= u.value { // house wins ties
                state.pcScore += 1
            }
        }
        onStateChange?(state)
    }

    func flipBackAndAdvance() {
        guard !state.isGameOver else { return }
        state.isFlipped = false
        onStateChange?(state)
        if state.round >= maxRounds {
            state.isGameOver = true
            onStateChange?(state)
        } else {
            state.round += 1
            onStateChange?(state)
        }
    }
}

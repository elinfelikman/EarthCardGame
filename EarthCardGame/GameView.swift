import SwiftUI

struct PlayingCard {
    var imageName: String
    var value: Int
}

struct GameView: View {
    var userName: String
    var isUserEastSide: Bool
    
    @State private var userScore = 0
    @State private var pcScore = 0
    @State private var currentRound = 1
    
    @State private var isFlipped = false
    @State private var userCard: PlayingCard? = nil
    @State private var pcCard: PlayingCard? = nil
    @State private var isGameOver = false
    
    let deck = [
        PlayingCard(imageName: "tortoise.fill", value: 2),
        PlayingCard(imageName: "hare.fill", value: 4),
        PlayingCard(imageName: "car.fill", value: 6),
        PlayingCard(imageName: "bus.fill", value: 8),
        PlayingCard(imageName: "airplane", value: 10)
    ]
    
    var body: some View {
        VStack {
            Text("Round \(min(currentRound, 10))/10")
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()
            
            HStack {
                VStack {
                    Text(isUserEastSide ? "PC" : userName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(isUserEastSide ? pcScore : userScore)")
                        .font(.system(size: 50, weight: .bold))
                }
                
                Spacer()
                
                VStack {
                    Text(isUserEastSide ? userName : "PC")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(isUserEastSide ? userScore : pcScore)")
                        .font(.system(size: 50, weight: .bold))
                }
            }
            .padding(.horizontal, 50)
            
            Spacer()
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isFlipped ? Color.white : Color.gray.opacity(0.4))
                        .frame(width: 120, height: 180)
                        .shadow(radius: isFlipped ? 5 : 0)
                    
                    if isFlipped, let leftCard = (isUserEastSide ? pcCard : userCard) {
                        Image(systemName: leftCard.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    } else {
                        Text("?")
                            .font(.largeTitle)
                    }
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isFlipped ? Color.white : Color.gray.opacity(0.4))
                        .frame(width: 120, height: 180)
                        .shadow(radius: isFlipped ? 5 : 0)
                    
                    if isFlipped, let rightCard = (isUserEastSide ? userCard : pcCard) {
                        Image(systemName: rightCard.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    } else {
                        Text("?")
                            .font(.largeTitle)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startGameLoop()
        }
        .navigationDestination(isPresented: $isGameOver) {
                    SummaryView(userName: userName, userScore: userScore, pcScore: pcScore)
        }
    }
    
    private func startGameLoop() {
        guard currentRound <= 10 else { return }
        
        userCard = deck.randomElement()
        pcCard = deck.randomElement()
        
        isFlipped = true
        
        if let uCard = userCard, let pCard = pcCard {
            if uCard.value > pCard.value {
                userScore += 1
            } else if pCard.value > uCard.value {
                pcScore += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isFlipped = false
            
            if currentRound == 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isGameOver = true
                }
            } else {
                currentRound += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    startGameLoop()
                }
            }
        }
    }
}

#Preview {
    GameView(userName: "elin", isUserEastSide: false)
}

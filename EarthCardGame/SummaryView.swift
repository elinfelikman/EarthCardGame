import SwiftUI

struct SummaryView: View {
    var userName: String
    var userScore: Int
    var pcScore: Int
    
    // לוגיקת בחירת המנצח (כולל חוק התיקו שבו הבית מנצח)
    var winnerName: String {
        if userScore > pcScore {
            return userName
        } else {
            return "PC"
        }
    }
    
    var winningScore: Int {
        if userScore > pcScore {
            return userScore
        } else {
            return pcScore
        }
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            Text("Winner: \(winnerName)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("score: \(winningScore)")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            // מעבר חזרה למסך הראשי
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                Text("BACK TO MENU")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(width: 150, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // מונע חזרה אחורה בעזרת החלקה או כפתור מובנה
    }
}

#Preview {
    SummaryView(userName: "Gabi", userScore: 10, pcScore: 8)
}

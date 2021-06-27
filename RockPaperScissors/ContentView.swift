//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Bruce Gilmour on 2021-06-27.
//

import SwiftUI

struct ContentView: View {
    let gameChoices = ["👊", "✋", "✌️"]

    @State private var gameChoice = Int.random(in: 0 ... 2)
    @State private var shouldWin = Bool.random()
    @State private var playerScore = 0
    @State private var currentRound = 1
    @State private var gameOver = false

    var body: some View {
        ZStack {
            gameBackground

            GameVStack {
                gameTitle

                Spacer()

                gameHasChosen

                instructPlayer

                gameButtons

                gameScore
            }
        }
        .alert(isPresented: $gameOver) {
            gameAlert
        }
    }

    var gameBackground: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }

    var gameTitle: some View {
        VStack {
            Text("Rock 👊 Paper ✋")
            Text("Scissors ✌️")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding(.top, 10)
    }

    var gameHasChosen: some View {
        HStack {
            Text("Game has chosen: ")
            Text("\(gameChoices[gameChoice])")
                .font(.largeTitle)
        }
        .padding(.vertical, 50)
    }

    var instructPlayer: some View {
        if shouldWin {
            return HStack {
                Text("Make a choice that will")
                Text("win")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
            }
        } else {
            return HStack {
                Text("Make a choice that will")
                Text("lose")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.red)
            }
        }
    }

    var gameButtons: some View {
        HStack(spacing: 10) {
            ForEach(gameChoices, id: \.self) { choice in
                GameButton(label: choice) {
                    updateGameState(for: choice)
                }
            }
        }
        .padding(.vertical, 30)
    }

    var gameScore: some View {
        VStack(spacing: 10) {
            Text("Round \(currentRound) of 10")
            Text("Score: \(playerScore)")
        }
        .padding(.top, 50)
    }

    var gameAlert: Alert {
        Alert(title: Text("Game Over"),
              message: Text("Final score is \(playerScore)"),
              dismissButton: .default(Text("Play again")) {
            self.resetGame()
        })
    }

    func updateGameState(for choice: String) {
        let playerChoice = gameChoices.firstIndex(of: choice)!
        let winningChoice = (gameChoice + 1) % 3

        if shouldWin && playerChoice == winningChoice {
            playerScore += 10
        } else if !shouldWin && playerChoice != winningChoice {
            playerScore += 10
        } else {
            playerScore -= 5
        }

        if currentRound < 10 {
            currentRound += 1
        } else {
            gameOver = true
        }
        updateGameChoices()
    }

    func resetGame() {
        playerScore = 0
        currentRound = 1
        updateGameChoices()
    }

    func updateGameChoices() {
        gameChoice = Int.random(in: 0 ... 2)
        shouldWin = Bool.random()
    }
}

struct GameVStack<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack {
            self.content()
        }
        .font(.title2)
        .foregroundColor(.white)
    }
}
struct GameButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(label) {
            action()
        }
        .font(.largeTitle)
        .frame(width: 80, height: 80)
        .foregroundColor(.white)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.white, lineWidth: 2))
        .shadow(color: .black, radius: 3)
        .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

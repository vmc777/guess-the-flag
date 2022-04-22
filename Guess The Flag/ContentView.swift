//
//  ContentView.swift
//  Guess The Flag
//
//  Created by VerDel on 4/17/22.
//

import SwiftUI

struct ContentView: View {
  @State private var answeredEight = false
  @State private var totalQuestionsAsked = 0
  @State private var numberCorrect = 0
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var countries = ["France", "Germany", "Estonia", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"] // .shuffled()
  @State private var correctAnswer = Int.random(in: 0 ... 2)
  @State private var newScore = 0

  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
      VStack {
        Spacer()
        Text("Guess the Flag")
          .font(.largeTitle.weight(.bold))
          .foregroundColor(.white)
        guessBox()
        Spacer()
        Text("Score: \(newScore)")
          .foregroundColor(.blue)
          .font(.title.bold())
        Spacer()
      }
      .padding()
    }
    .alert(scoreTitle, isPresented: $showingScore) {
      Button("Continue", action: askQuestion)
    } message: {
      Text("Your score is \(newScore)")
    }
    .alert(scoreTitle, isPresented: $answeredEight) {
      Button("Play Again", action: startOver)
    } message: {
      Text("Your end score is \(newScore). You got \(numberCorrect) out of 8 questions correct. See if you can beat that next time.")
    }
  }

  func guessBox() -> some View {
    VStack(spacing: 15) {
      VStack {
        Text("Tap the flag of")
          .font(.subheadline.weight(.heavy))
          .foregroundStyle(.secondary)

        Text(countries[correctAnswer])
          .font(.largeTitle.weight(.semibold))
      }
      ForEach(0 ..< 3) { number in
        Button {
          flagTapped(number)
        } label: {
          Image(countries[number])
            .renderingMode(.original)
            .shadow(radius: 5)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }

  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      scoreTitle = "Correct!"
      numberCorrect += 1
      newScore += 10
    } else {
      scoreTitle = "Wrong. That was the flag for \(countries[number])"
      newScore -= 15
    }
    totalQuestionsAsked += 1
    if totalQuestionsAsked == 8 {
      answeredEight = true
    } else {
      showingScore = true
    }
  }

  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ... 2)
  }

  func startOver() {
    newScore = 0
    totalQuestionsAsked = 0
    numberCorrect = 0
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ... 2)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

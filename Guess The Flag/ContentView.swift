//
//  ContentView.swift
//  Guess The Flag
//
//  Created by VerDel on 4/17/22.
//

import SwiftUI

let QUESTIONS_PER_ROUND = 8
let CORRECT_GUESS_DELTA = 10
let INCORRECT_GUESS_DELTA = -15
let OPTIONS_PER_GUESS = 3

struct ContentView: View {
  @State private var roundComplete = false
  @State private var questionsAskedThisRound = 0
  @State private var numberCorrect = 0
  @State private var showingScore = false
  @State private var guessResult = ""
  @State private var roundResults = ""
  @State private var countries = ["France", "Germany", "Estonia", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]  .shuffled()
  @State private var correctAnswer = Int.random(in: 0 ..< OPTIONS_PER_GUESS)
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
    .alert(guessResult, isPresented: $showingScore) {
      Button("Continue", action: checkForEndOfRound)
    } message: {
      Text("Your score is \(newScore)")
    }
    .alert(roundResults, isPresented: $roundComplete) {
      Button("Play Again", action: startNewRound)
    } message: {
      Text("See if you can beat that next time.")
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
      guessResult = "Correct!"
      numberCorrect += 1
      newScore += CORRECT_GUESS_DELTA
    } else {
      guessResult = "Wrong. That was the flag for \(countries[number])"
      newScore += INCORRECT_GUESS_DELTA
    }
    showingScore = true
  }

  func checkForEndOfRound() {
    questionsAskedThisRound += 1
    if questionsAskedThisRound == QUESTIONS_PER_ROUND {
      roundComplete = true
      roundResults = "Your end score is \(newScore). You got \(numberCorrect) out of 8 questions correct."
    } else {
      pickNewFlag()
    }
  }

  func pickNewFlag() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ..< OPTIONS_PER_GUESS)
  }

  func startNewRound() {
    pickNewFlag()
    newScore = 0
    questionsAskedThisRound = 0
    numberCorrect = 0
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

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
    @State private var questionNumber = 0
    @State private var numberCorrect = 0
    @State private var showingScore = false
    @State private var guessResult = ""
    @State private var roundResults = ""
    @State private var newScore = 0

    @State private var countries = ["France", "Germany", "Estonia", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ..< OPTIONS_PER_GUESS)
    @State private var tappedFlagIndex: Int? = nil

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                GuessBox(countries: countries,
                         correctAnswer: correctAnswer,
                         tappedFlagIndex: tappedFlagIndex,
                         answer: answer)
                Spacer()
                Text("Score: \(newScore)")
                    .scoreStyle()
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

    func answer(tappedFlag: Int) {
        tappedFlagIndex = tappedFlag
        let isCorrect = tappedFlag == correctAnswer
        if isCorrect {
            guessResult = "Correct!"
            numberCorrect += 1
            newScore += CORRECT_GUESS_DELTA
        } else {
            guessResult = "Wrong. That was the flag for \(correctAnswer)"
            newScore += INCORRECT_GUESS_DELTA
        }
        showingScore = true
    }

    func checkForEndOfRound() {
        questionNumber += 1
        if questionNumber == QUESTIONS_PER_ROUND {
            roundComplete = true
            roundResults = "Your end score is \(newScore). You got \(numberCorrect) out of 8 questions correct."
        } else {
            pickNewFlag()
        }
    }

    func startNewRound() {
        newScore = 0
        questionNumber = 0
        numberCorrect = 0
        pickNewFlag()
    }

    func pickNewFlag() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ..< OPTIONS_PER_GUESS)
        tappedFlagIndex = nil
    }
}

struct GuessBox: View {
    var countries: [String]
    var correctAnswer: Int
    var tappedFlagIndex: Int?
    var answer: (Int) -> ()

    var body: some View {
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
                }
          label: {
                    FlagImage(country: countries[number])
                        .rotation3DEffect(
                            .degrees(number == tappedFlagIndex ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0))
                        .opacity(number == tappedFlagIndex || tappedFlagIndex == nil ? 1 : 0.25)
                        .animation(tappedFlagIndex == nil ? .none : .easeInOut(duration: 1), value: tappedFlagIndex)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    func flagTapped(_ number: Int) {
        answer(number)
    }
}

struct FlagImage: View {
    var country: String
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .shadow(radius: 5)
    }
}

struct Score: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func scoreStyle() -> some View {
        modifier(Score())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

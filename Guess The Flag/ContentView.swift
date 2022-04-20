//
//  ContentView.swift
//  Guess The Flag
//
//  Created by VerDel on 4/17/22.
//

import SwiftUI

struct ContentView: View {
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var countries = ["France", "Germany", "Estonia", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"] // .shuffled()
  @State private var correctAnswer = Int.random(in: 0 ... 2)
  @State private var newScore = 0

  var body: some View {
    ZStack {
//      RadialGradient(stops: [
//        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
//        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
//      ], center: .top, startRadius: 200, endRadius: 400)
//        .ignoresSafeArea()
      LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
      VStack {
        Spacer()
        Text("Guess the Flag")
          .font(.largeTitle.weight(.bold))
          .foregroundColor(.white)
        guessBox()
        Spacer()
//        Spacer()
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
  }

  func guessBox() -> some View {
    VStack(spacing: 15) {
      VStack {
        Text("Tap the flag of")
          .font(.subheadline.weight(.heavy))
          .foregroundStyle(.secondary)

        Text(countries[correctAnswer])
          .font(.largeTitle.weight(.semibold))
//              .foregroundColor(.black )
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
      scoreTitle = "Correct. Go have an ice cream."
      newScore += 10
    } else {
      scoreTitle = "Wrong! That was the flag for \(countries[number])"
      newScore -= 15
    }
    showingScore = true
  }

  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ... 2)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

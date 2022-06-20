//
//  GuessBox.swift
//  Guess The Flag
//
//  Created by VerDel on 6/20/22.
//

import SwiftUI

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
            let isTappedFlag = number == tappedFlagIndex
            let noFlagsTapped = tappedFlagIndex == nil
            let scale = isTappedFlag || noFlagsTapped ? 1.0 : 0.8
            FlagImage(country: countries[number])
              .rotation3DEffect(
                .degrees(number == tappedFlagIndex ? 360 : 0),
                axis: (x: 0, y: 1, z: 0))
              .opacity(isTappedFlag || noFlagsTapped ? 1 : 0.25)
              .scaleEffect(x: scale, y: scale)
              .animation(noFlagsTapped ? .none : .easeInOut(duration: 1), value: tappedFlagIndex)
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

//
//
//
//
//

struct GuessBox_Previews: PreviewProvider {
  static var previews: some View {
    let tappedFlagIndex: Int? = nil
    GuessBox(countries: ["US", "Russia", "Poland"],
             correctAnswer: 0,
             tappedFlagIndex: tappedFlagIndex,
             answer: { _ in })
  }
}

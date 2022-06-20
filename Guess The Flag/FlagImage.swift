//
//  FlagImage.swift
//  Guess The Flag
//
//  Created by VerDel on 6/20/22.
//

import SwiftUI

struct FlagImage: View {
  var country: String
  var body: some View {
    Image(country)
      .renderingMode(.original)
      .shadow(radius: 5)
  }
}

struct FlagImage_Previews: PreviewProvider {
  static var previews: some View {
    FlagImage(country: "US")
  }
}

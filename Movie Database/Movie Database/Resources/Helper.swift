//
//  Helper.swift
//  Movie Database
//
//  Created by Srinivas Prayag Sahu on 19/07/23.
//

import SwiftUI

extension Array where Element: Hashable {
  func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
    var result = [Element]()
    var seen = Set<T>()
    for value in self {
      if seen.insert(key(value)).inserted {
        result.append(value)
      }
    }
    return result
  }
  
}

extension String {
  var withoutPunctuations: String {
    return self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
  }
}

extension Image {
  func data(url: URL) -> Self {
    if let data = try? Data(contentsOf: url) {
      return Image(uiImage: UIImage(data: data)!)
        .resizable()
    }
    return self.resizable()
  }
}

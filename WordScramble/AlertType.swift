//
//  AlertType.swift
//  WordScramble
//
//  Created by Farhad Bagherzadeh on 11/11/2022.
//

import Foundation

enum AlertType: Equatable {
  case readingFileError
  case shortOrRootError(String)
  case isOriginalError(String)
  case isPossibleError(String)
  case isRealWordError(String)
  case scoreCalculation
  case reset

  var title: String {
    switch self {
    case .readingFileError:
      return "Something went wrong"
    case .shortOrRootError:
      return "Short or Root"
    case .isOriginalError:
      return "Not original"
    case .isPossibleError:
      return "Not possible"
    case .isRealWordError:
      return "Not real word"
    case .scoreCalculation:
      return "Score calculation"
    case .reset:
      return "Reset game"
    }
  }

  var message: String {
    switch self {
    case .readingFileError:
      return "Could not load start.txt from bundle.\nTry removing and reinstalling the app."
    case .shortOrRootError(let word):
      return "`\(word)` is either the root word OR less than 3 letters."
    case .isOriginalError(let word):
      return "`\(word)` is already used."
    case .isPossibleError(let word):
      return "`\(word)` is not possible based on root word letters."
    case .isRealWordError(let word):
      return "`\(word)` is not a real word."
    case .scoreCalculation:
      return "5 points for each new word, and 1 point for each letter in a word. \nTry finding longer words for higher score!"
    case .reset:
      return "A new root word will be picked, and score and guessed words will be reset. \n Are you sure?"
    }
  }
}

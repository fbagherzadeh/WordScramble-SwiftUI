//
//  ContentView.swift
//  WordScramble
//
//  Created by Farhad Bagherzadeh on 10/11/2022.
//

import SwiftUI

struct ContentView: View {
  @State private var usedWords: [String] = []
  @State private var rootWord: String = ""
  @State private var newWord: String = ""

  @State private var score: Int = 0
  @State private var showAlert: Bool = false
  @State private var showResetAlert: Bool = false
  @State private var alertType: AlertType = .scoreCalculation

  var body: some View {
    NavigationView {
      VStack {
        listView
        scoreView
      }
      .navigationTitle(rootWord.capitalized)
      .onSubmit(addNewWord)
      .onAppear(perform: startGame)
      .alert(alertType.title, isPresented: $showAlert) {
        Button(alertType == .reset ? "Reset" : "OK", role: alertType == .reset ? .none : .cancel) {
          if alertType == .reset {
            startGame()
          }
        }

        if alertType == .reset {
          Button("Cancel", role: .cancel) {}
        }
      } message: {
        Text(alertType.message)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { configureAlert(.reset) }) {
            Image(systemName: "arrow.clockwise.circle.fill")
              .foregroundColor(.primary)
          }
        }
      }
    }
  }
}

private extension ContentView {
  var listView: some View {
    List {
      Section {
        TextField("Enter new word", text: $newWord)
          .autocorrectionDisabled()
      }

      Section {
        ForEach(usedWords, id: \.self) { word in
          HStack(alignment: .center) {
            Image(systemName: "\(word.count).circle")
            Text(word.capitalized)
          }
        }
      }
    }
    .listStyle(.insetGrouped)
  }

  var scoreView: some View {
    Text("Your score: \(score)")
      .padding(.bottom)
      .animation(.default, value: score)
      .overlay {
        Button(action: scoreHelp) {
          Image(systemName: "exclamationmark.circle.fill")
            .foregroundColor(.primary)
        }
        .offset(x: 75, y: -7)
      }
  }
}

private extension ContentView {
  func addNewWord() {
    let trimmedNewWord: String = newWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !trimmedNewWord.isEmpty else { return }

    guard !isShorterThanThreeOrRootWord(trimmedNewWord) else {
      configureAlert(.shortOrRootError(newWord))
      return
    }

    guard isOriginal(trimmedNewWord) else {
      configureAlert(.isOriginalError(newWord))
      return
    }

    guard isPossible(trimmedNewWord) else {
      configureAlert(.isPossibleError(newWord))
      return
    }

    guard isRealWord(trimmedNewWord) else {
      configureAlert(.isRealWordError(newWord))
      return
    }


    withAnimation {
      usedWords.insert(trimmedNewWord, at: 0)
      score += (trimmedNewWord.count + 5)
    }
    newWord = ""
  }

  func isShorterThanThreeOrRootWord(_ newWord: String) -> Bool {
    return newWord.count < 3 || newWord == rootWord
  }

  func isOriginal(_ newWord: String) -> Bool {
    !usedWords.contains(newWord)
  }

  func isPossible(_ newWord: String) -> Bool {
    for letter in newWord {
      if !rootWord.contains(letter) {
        return false
      }
    }

    return true
  }

  func isRealWord(_ newWord: String) -> Bool {
    let checker: UITextChecker = .init()
    let range: NSRange = .init(location: 0, length: newWord.utf16.count)
    let misspelledRange: NSRange = checker.rangeOfMisspelledWord(in: newWord, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }

  func configureAlert(_ type: AlertType) {
    alertType = type
    newWord = ""
    showAlert = true
  }

  func startGame() {
    guard let url = Bundle.main.url(forResource: "start", withExtension: "txt"),
          let string = try? String(contentsOf: url) else {
      configureAlert(.readingFileError)
      return
    }

    let words = string.components(separatedBy: "\n")
    rootWord = (words.randomElement() ?? "amateurs")
    usedWords = []
    newWord = ""
    score = 0
  }

  func scoreHelp() {
    configureAlert(.scoreCalculation)
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

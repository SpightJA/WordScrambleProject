//
//  WordScrambleViewModel.swift
//  WordScramble
//
//  Created by Jon Spight on 4/26/24.
//

import Foundation
import SwiftUI

@Observable
class WordScrambleViewModel {
    var usedWords       = [String]()
    var rootWord        = ""
    var newWord         = ""
    var errorTitle      = ""
    var errorMessage    = ""
    var showingAlert    = false
    var score           = 0
    
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        //extra validation
        guard isOriginal(word: answer) else {
            wordError(title: "Word already in use", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "you cant spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word does not exist", message: "You cant make up words!")
            return
        }
        guard isValidLength(word: answer) else {
            wordError(title: "Word is not long enough", message: "Use more letters")
            return
        }
        guard isNotRoot(word: answer) else {
            wordError(title: "Thats the Root word!", message: "you cant use the root word!")
            return
        }
        
        
        withAnimation{
            usedWords.insert(answer, at: 0)
            score += answer.count
        }
        newWord = ""
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // we found the file
            if let startWords = try? String(contentsOf: startWordsURL) {
                //we loaded the file
                let allWordsArray = startWords.components(separatedBy: "\n")
                rootWord = allWordsArray.randomElement() ?? "silkworm"
                score = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isNotRoot(word: String) -> Bool {
        !(rootWord == word)
    }
    
    func isOriginal(word : String ) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word : String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){ //if we find that letter save the position
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isValidLength(word: String) -> Bool {
        word.count > 2
        
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingAlert = true
    }
}

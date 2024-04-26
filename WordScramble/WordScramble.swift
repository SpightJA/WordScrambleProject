//
//  ContentView.swift
//  WordScramble
//
//  Created by Jon Spight on 4/17/24.
//

import SwiftUI

struct WordScramble: View {
    @State private var viewModel = WordScrambleViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
            List {
                newWordView(word: $viewModel.newWord)
                wordsView(usedWords: viewModel.usedWords)
            }
                Text("Score \(viewModel.score)")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
            .navigationTitle(viewModel.rootWord)
            .onSubmit {
                viewModel.addNewWord()
            }
            .onAppear(){
                viewModel.startGame()
            }
            .alert(viewModel.errorTitle, isPresented: $viewModel.showingAlert) {} message: {
                Text(viewModel.errorMessage)
            }
            .toolbar(content: {
                Button("Restart", action: viewModel.startGame)
            })
        }
    }
    

}

#Preview {
    WordScramble()
}

struct newWordView: View {
    @Binding var word : String
    var body: some View {
        Section{
            TextField("Enter your word", text: $word)
                .textInputAutocapitalization(.never)
        }
    }
}

struct wordsView: View {
    var usedWords : [String]
    var body: some View {
        Section{
            ForEach(usedWords, id: \.self) { word in
                HStack {
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                }
            }
        }
    }
}

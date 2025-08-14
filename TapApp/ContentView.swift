//
//  ContentView.swift
//  TapApp
//
//  Created by Binary Semantics on 08/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var picIndex: Int = 0
    let possiblePics: [String] = ["apple", "dog", "egg"]
    @State private var score: Int = 0
    @State private var targetIndex = 1
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var difficulty: Difficulty = .easy
    @State private var isGameRunning = true
    
    enum Difficulty: Double {
        case easy = 1, medium = 0.3, hard = 0.1
        
        var title: String {
            switch self {
            case .easy: return "Easy"
            case .medium: return "Medium"
            case .hard: return "Hard"
            }
        }
    }
    
    var randomTarget : Int{
        return Int.random(in: 0..<possiblePics.count)
    }
    
    var body: some View {
        VStack {
            HStack{
                Menu("Difficulty"){
                    Button(Difficulty.easy.title){
                        difficulty = .easy
                        timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
                    }
                    Button(Difficulty.medium.title){
                        difficulty = .medium
                        timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
                    }
                    Button(Difficulty.hard.title){
                        difficulty = .hard
                        timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
                    }
                }
                Spacer()
                Text("Score: \(score)")
            }
            .padding(.horizontal)
          
              Image(possiblePics[picIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 350)
                    .onTapGesture {
                        timer.upstream.connect().cancel()
                        if picIndex == targetIndex {
                            if isGameRunning{score += 1}
                            alertTitle = "Success!"
                            alertMsg = "You got it right!"
                        }else{
                            alertTitle = "Incorrect."
                            alertMsg = "You got it wrong!"
                        }
                        showAlert = true
                        isGameRunning = false
                    }
            Text(possiblePics[targetIndex])
                .font(.largeTitle)
                .padding(.top)
            
            if !isGameRunning {
                Button("Restart Game"){
                    isGameRunning = true
                    targetIndex = randomTarget
                    timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
                }
            }
            
        }
        .onReceive(timer, perform: {_ in
            if picIndex == possiblePics.count - 1 {
                picIndex = 0
            }
            else {
                picIndex += 1
            }
        })
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button("OK", action: {})
        }, message: {
            Text(alertMsg)
        })
        
    }
}

#Preview {
    ContentView()
}

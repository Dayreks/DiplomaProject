//
//  ContentView.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var macroModuleName = "" 
    
    let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")

    var body: some View {
        VStack {
            Text("Enter the name of the main macro module")
                .font(.headline)
                .padding(.bottom, 2)
            
            TextField("Macro Module Name", text: $macroModuleName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 20)
            
            Button("Save Preferences") {
                defaults?.set(macroModuleName, forKey: "macroModuleName")
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

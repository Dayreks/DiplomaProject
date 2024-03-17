//
//  ContentView.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var inputCode = ""
    @State private var outputCode = ""
    @State private var resultPreview = ""

    let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")

    var body: some View {
        VStack {
            // Input Code Text Editor
            Text("Input")
                .font(.headline)
                .padding(.bottom, 2)
            TextEditor(text: $inputCode)
                .frame(minHeight: 100)
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)

            // Output Code Text Editor
            Text("Output")
                .font(.headline)
                .padding(.bottom, 2)
            TextEditor(text: $outputCode)
                .frame(minHeight: 100)
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)

            // Preview Window
            VStack {
                Text("Preview")
                    .font(.headline)
                    .padding(.bottom, 2)
                Text(resultPreview)
                    .frame(minHeight: 100)
                    .border(Color.gray, width: 1)
                    .padding(.bottom, 20)
            }

            // Generate Button
            Button("Generate") {
                // Here you can implement the logic for generating the preview
                // For this example, I'll just concatenate input and output
                resultPreview = "Input: \(inputCode)\nOutput: \(outputCode)"

                // Saving input and output to UserDefaults
                defaults?.set(inputCode, forKey: "inputCode")
                defaults?.set(outputCode, forKey: "outputCode")
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


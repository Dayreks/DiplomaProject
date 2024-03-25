//
//  ContentView.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var moduleName = ""
    @State private var macroName = ""
    @State private var inputCode = ""
    @State private var outputCode = ""
    @State private var resultPreview = ""

    let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")

    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            // Module Name Text Field
            Text("Module Name")
                .font(.headline)
                .padding(.bottom, 2)
            TextField("Enter module name", text: $moduleName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)
            
            Text("Macro Name")
                .font(.headline)
                .padding(.bottom, 2)
            TextField("Enter macro name", text: $macroName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 20)
            
            Text("Input")
                .font(.headline)
                .padding(.bottom, 2)
            TextEditor(text: $inputCode)
                .frame(minHeight: 100)
                .font(.system(size: 14))
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)

            // Output Code Text Editor
            Text("Output")
                .font(.headline)
                .padding(.bottom, 2)
            TextEditor(text: $outputCode)
                .font(.system(size: 14))
                .frame(minHeight: 100)
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)

            // Preview Window
            VStack {
                Text("Preview")
                    .font(.headline)
                    .padding(.bottom, 2)
                ScrollView(.vertical) {
                    Text(resultPreview)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                        .padding()
                }
                .frame(minHeight: 200)
                .border(Color.black, width: 1)
                .padding(.bottom, 20)
            }

            // Generate Button
            Button("Save") {
                resultPreview = "Module: \n\(moduleName)\n\nMacroName: \n\(macroName)\n\nInput: \n\(inputCode)\n\nOutput: \n\(outputCode)"

                // Saving module name, input, and output to UserDefaults
                defaults?.set(moduleName, forKey: "moduleName")
                defaults?.set(macroName, forKey: "macroName")
                defaults?.set(inputCode, forKey: "inputCode")
                defaults?.set(outputCode, forKey: "outputCode")
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Spacer().frame(height: 32)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


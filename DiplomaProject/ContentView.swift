//
//  ContentView.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            // Module Name Text Field
            Text("Module Name")
                .font(.headline)
                .padding(.bottom, 2)
            TextField("Enter module name", text: $viewModel.moduleName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)
            
            Text("Macro Name")
                .font(.headline)
                .padding(.bottom, 2)
            TextField("Enter macro name", text: $viewModel.macroName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 20)
            
            Text("Input")
                .font(.headline)
                .padding(.bottom, 2)
            TextEditor(text: $viewModel.inputCode)
                .frame(minHeight: 100)
                .font(.system(size: 14))
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)

            // Output Code Text Editor
            Text("Output")
                .font(.headline)
                .padding(.bottom, 2)
                .foregroundColor(viewModel.isOutputBlocked ? .gray : .primary)
            TextEditor(text: $viewModel.outputCode)
                .font(.system(size: 14))
                .frame(minHeight: 100)
                .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
                .opacity(viewModel.isOutputBlocked ? 0.5 : 1)
                .disabled(viewModel.isOutputBlocked)

            // Preview Window
            VStack {
                Text("Preview")
                    .font(.headline)
                    .padding(.bottom, 2)
                ScrollView(.vertical) {
                    Text(viewModel.resultPreview)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                        .padding()
                }
                .frame(minHeight: 200)
                .border(Color.black, width: 1)
                .padding(.bottom, 20)
            }

            // Generate Button
            Button("Generate Macro") {
                viewModel.buildMacro()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Button("Copy Preview") {
                viewModel.copyPreviewToClipboard()
            }
            .padding()
            .buttonStyle(.bordered)
            
            Spacer().frame(height: 32)
        }
        .padding()
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


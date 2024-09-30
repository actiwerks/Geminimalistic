//
//  ContentView.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 26.01.2024.
//

import SwiftUI


struct MainView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var prompt = ""
    @FocusState private var promptFocused: Bool
    @State private var promptExpanded = true
    
    @ObservedObject private var onboardingModel = OnboardingModel.shared
    @ObservedObject private var model = GeminiModel.shared
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List {
                    if onboardingModel.useOnboardingModel {
                        ForEach(onboardingModel.conversation, id: \.self) { item in
                            ConversationPairView(data: item)
                                .swipeActions {
                                    deleteItemButton {
                                        if let index = onboardingModel.conversation.firstIndex(of: item) {
                                            onboardingModel.conversation.remove(at: index)
                                        }
                                    }
                                }
                        }
                    }
                    ForEach(model.conversation, id: \.self) { item in
                        ConversationPairView(data: item)
                            .swipeActions {
                                deleteItemButton {
                                    if let index = model.conversation.firstIndex(of: item) {
                                        model.conversation.remove(at: index)
                                    }
                                }
                            }
                    }
                    if let lastPrompt = model.pendingPrompt {
                        ConversationPairView(data: lastPrompt)
                    }
                }
                .emptyListPlaceholder(model.conversation.isEmpty && onboardingModel.conversation.isEmpty, emptyListContent)
                .listStyle(PlainListStyle())
                .onChange(of: model.lastGeneratedResponse) { oldValue, newValue in
                    prompt = ""
                    promptExpanded = false
                    if let lastItem = model.conversation.last {
                        proxy.scrollTo(lastItem, anchor: .top)
                    }
                }
                .onChange(of: onboardingModel.lastOnboardingResponse) { oldValue, newValue in
                    prompt = ""
                    promptFocused = false
                    promptExpanded = false
                    if let lastItem = onboardingModel.conversation.last {
                        proxy.scrollTo(lastItem, anchor: .top)
                    }
                }
                
                Spacer()
                    .frame(height: 5.0)
                HStack {
                    Text("Enter your query:")
                    Spacer()
                    if !model.conversation.isEmpty || !onboardingModel.conversation.isEmpty {
                        Button {
                            promptExpanded.toggle()
                        } label: {
                            Image(systemName: promptExpanded ? "arrowtriangle.down" : "arrowtriangle.up")
                        }
                    }
                }
                if promptExpanded {
                    TextEditor(text: $prompt)
                        .focused($promptFocused)
                    HStack {
                        Spacer()
                        Button {
                            if onboardingModel.useOnboardingModelPromptProcessing {
                                if onboardingModel.textPrompt(prompt) {
                                    return
                                }
                            }
                            if model.textPrompt(prompt) {
                                if let lastPrompt = model.pendingPrompt {
                                    proxy.scrollTo(lastPrompt, anchor: .bottom)
                                }
                                promptFocused = false
                            }
                        } label: {
                            HStack {
                                Image(systemName: "lightbulb.2")
                                Text("Ask")
                            }
                        }
                        .disabled(prompt.isEmpty)
                    }
                }
            }
        }
        .padding()
    }
    
    var emptyListContent: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            if model.pendingPrompt == nil {
                Text("Please ask your question first")
            } else {
                ProgressView()
            }
            Spacer()
                .frame(height: 20)
        }
    }
    
    @ViewBuilder func deleteItemButton(_ deleteBlock: @escaping () -> Void) -> some View {
        Button("Delete", systemImage: "trash", role: .destructive) {
            deleteBlock()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//
//  GeminiModel.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 28.01.2024.
//

import Foundation
import GoogleGenerativeAI

class GeminiModel: ObservableObject, Conversational {
    
    static let shared = GeminiModel()
    
    static let geminiType = "gemini-1.5-flash"
    
    @Published var generationInProgress: Bool = false
    @Published var pendingPrompt: Pair?
    @Published var lastResponse: String = ""
    
    @Published var conversation: [Pair] = []
    
    private var conversationAsModelContent: [ModelContent] {
        conversation.flatMap { pair in
            pair.content
        }
    }
    
    private var onboardingModel = OnboardingModel.shared
    
    private var generativeModel =
    GenerativeModel(
        name: GeminiModel.geminiType,
        apiKey: APIKey.default
    )
    
    private init() {
        onboardingModel.conversationalParent = self
        if onboardingModel.useOnboardingModel {
            for pair in onboardingModel.conversation {
                conversation.append(pair)
            }
        }
    }
    
    func recreateModelUsingAPIKey(_ apiKey: String) {
        generativeModel =
        GenerativeModel(
            name: GeminiModel.geminiType,
            apiKey: apiKey
        )
    }
    
    func testKeyValidity() async -> Bool {
        do {
            let response = try await generativeModel.generateContent("Please reply Yes.")
            if response.text != nil {
                return true
            }
            print("Unexpected answer: \(response)")
        } catch {
            print("Expected PERMISSION_DENIED error, meaning there is no API key \(error)")
        }
        return false
    }
    
    func textPrompt(_ prompt: String) -> Bool {
        guard generationInProgress == false else {
            return false
        }
        generationInProgress = true
        Task { @MainActor in
            do {
                if onboardingModel.useOnboardingModelPromptProcessing {
                    if onboardingModel.textPrompt(prompt) {
                        generationInProgress = false
                        return
                    }
                }
                pendingPrompt = Pair(prompt)
                let response = conversation.isEmpty ? try await generativeModel.generateContent(prompt) : try await generativeModel.generateContent(withMutator(conversationAsModelContent) {
                    if let promptAsModelContent = try? ModelContent(role: "user", prompt) {
                        $0.append(promptAsModelContent)
                    }
                })
                if let text = response.text {
                    lastResponse = text
                } else {
                    lastResponse = "Prompt produced no response"
                }
            } catch {
                lastResponse = "Error generating response: \(error)"
            }
            if let pendingPrompt {
                pendingPrompt.answer = lastResponse
                conversation.append(pendingPrompt)
            }
            pendingPrompt = nil
            generationInProgress = false
        }
        return true
    }
    
    func withMutator<T>(_ value: T, mutator: (inout T) -> Void) -> T {
        var value = value
        mutator(&value)
        return value
    }
    
}

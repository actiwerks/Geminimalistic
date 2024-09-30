//
//  OnboardingModel.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 29.01.2024.
//

import Foundation

class OnboardingModel: ObservableObject, Conversational {
    
    static let shared = OnboardingModel()
    
    @Published var useOnboardingModel: Bool = false
    @Published var useOnboardingModelPromptProcessing: Bool = false
    
    @Published var testInProgress: Bool = false
    @Published var lastResponse = ""
    
    @Published var conversation: [Pair] = []
    
    var conversationalParent: Conversational?
    
    let step1 = "Welcome to Geminimalistic, generative artificial intelligence application. To get started, ask any question in the prompt below."
    let step2 = "I can't answer that just now. In order to use its Gemini AI model, you need to provide your own API key"
    let step3 = "That doesn't look like a valid API Key. You can obtain an API Key in Google AI Studio (https://aistudio.google.com/app/apikey). Please try again."
    let apiKeySuccess = "Provided API Key is valid and can be used. You are all set and can ask Gemini any questions at the prompt below."
    
    private init() {
        if APIKey.default.isEmpty {
            useOnboardingModel = true
            useOnboardingModelPromptProcessing = true
            conversation.append(Pair(prompt: "", answer: step1))
        }
    }
    
    func textPrompt(_ prompt: String) -> Bool {
        guard useOnboardingModelPromptProcessing else {
            return false
        }
        guard !testInProgress else {
            return false
        }
        testInProgress = true
        Task { @MainActor in
            GeminiModel.shared.recreateModelUsingAPIKey(prompt)
            let hasAPIKey = await GeminiModel.shared.testKeyValidity()
            if hasAPIKey {
                let succesPair = Pair(prompt: "", answer: apiKeySuccess)
                conversation.append(succesPair)
                conversationalParent?.conversation.append(succesPair)
                lastResponse = apiKeySuccess
                conversationalParent?.lastResponse = apiKeySuccess
                useOnboardingModelPromptProcessing = false
                APIKeyModel.apiKey = prompt
            } else {
                if conversation.count == 1 {
                    let step2Pair = Pair(prompt: prompt, answer: step2)
                    conversation.append(step2Pair)
                    conversationalParent?.conversation.append(step2Pair)
                    lastResponse = step2
                    conversationalParent?.lastResponse = step2
                } else {
                    let step3Pair = Pair(prompt: prompt, answer: step3)
                    conversation.append(step3Pair)
                    conversationalParent?.conversation.append(step3Pair)
                    lastResponse = "\(step3) \(conversation.count)"
                    conversationalParent?.lastResponse = "\(step3) \(conversation.count)"
                }
            }
            testInProgress = false
        }
        return true
    }
    
}

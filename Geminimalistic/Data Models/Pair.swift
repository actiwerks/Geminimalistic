//
//  Pair.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 14.02.2024.
//

import Foundation
import SwiftData
import GoogleGenerativeAI


@Model
class Pair: Hashable {
    
    var uuid: String
    var prompt: String
    var answer: String?
    
    var conversation: Conversation?
    
     @Transient var content: [ModelContent] {
        var content: [ModelContent] = []
        content.append(ModelContent(role: "user", parts: prompt))
        if let answer {
            content.append(ModelContent(role: "model", parts: answer))
        }
        return content
    }
    
    init() {
        uuid = UUID().uuidString
        prompt = ""
    }
    
    init(_ prompt: String) {
        uuid = UUID().uuidString
        self.prompt = prompt
    }
    
    init(prompt: String, answer: String) {
        uuid = UUID().uuidString
        self.prompt = prompt
        self.answer = answer
    }
    
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(prompt)
        hasher.combine(answer ?? "")
    }
}


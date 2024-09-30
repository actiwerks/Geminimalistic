//
//  Conversation.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 14.02.2024.
//

import Foundation
import SwiftData

@Model
class Conversation {
    var uuid: String
    var startDate: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Pair.conversation)  var conversationItems: [Pair] = []
    
    init() {
        uuid = UUID().uuidString
        startDate = Date.now
    }
    
    
}

//
//  Conversational.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 29.01.2024.
//

import Foundation

protocol Conversational {
    var conversation: [Pair] { get set }
    var lastResponse: String { get set }
}

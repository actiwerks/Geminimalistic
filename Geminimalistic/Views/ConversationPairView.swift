//
//  ConversationPairView.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 28.01.2024.
//

import Foundation
import SwiftUI

struct ConversationPairView: View {
    
    var data: Pair
    
    var body: some View {
        ZStack {
            VStack {
                if !data.prompt.isEmpty {
                    Text(.init(data.prompt))
                        .padding()
                        .background(Color("PromptBackgroundColor"))
                        .onTapGesture {}.onLongPressGesture(minimumDuration: 0.2) {
                            print("Copy: \(data.prompt)")
                            pasteData(data.prompt)
                        }
                }
                if let answer = data.answer {
                    Text(.init(answer))
                        .padding()
                        .background(Color("AnswerBackgroundColor"))
                        .onTapGesture {}.onLongPressGesture(minimumDuration: 0.2) {
                            if let answer = data.answer {
                                print("Copy: \(answer)")
                                pasteData(answer)
                            }
                        }

                } else {
                    ProgressView()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private func pasteData(_ data: String) {
        UIPasteboard.general.setValue(data, forPasteboardType: "public.plain-text")
    }
}

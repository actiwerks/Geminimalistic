//
//  EmptyDataModifier.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 28.01.2024.
//

import Foundation
import SwiftUI

struct EmptyDataModifier<Placeholder: View>: ViewModifier {
    
    let isEmpty: Bool
    let placeholder: Placeholder
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if !isEmpty {
            content
        } else {
            placeholder
        }
    }
}

extension List {
    
    func emptyListPlaceholder(_ isEmpty: Bool, _ placeholder: some View) -> some View {
        modifier(EmptyDataModifier(isEmpty: isEmpty, placeholder: placeholder))
    }
}

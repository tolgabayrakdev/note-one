//
//  PaddedTextFieldStyle.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct PaddedTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

extension View {
    func paddedTextFieldStyle() -> some View {
        modifier(PaddedTextFieldStyle())
    }
}


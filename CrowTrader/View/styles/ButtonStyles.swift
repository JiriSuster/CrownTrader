//
//  ButtonStyles.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 22.01.2025.
//

import SwiftUI

struct CrownButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 100)
            .foregroundStyle(Color.white)
            .font(.title2)
            .padding()
            .background(Color.green)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 2)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == CrownButtonStyle {
    static var crownButtonStyle: CrownButtonStyle { CrownButtonStyle() }
}

#Preview {
    VStack {

        Button("Test"){

        }
        .buttonStyle(.crownButtonStyle)

    }
}


//
//  ButtonStyles.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 22.01.2025.
//

import SwiftUI

struct DismissCrownButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 40, height: 10)
            .foregroundStyle(Color.white)
            .font(.callout)
            .padding()
            .background(Color.red)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 2)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct TimeframeButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(isSelected ? .bold : .regular)
            .padding()
            .frame(width: 60, height: 40)
            .background(
                isSelected ? Color.green : Color.gray.opacity(0.2)
            )
            .foregroundColor(
                isSelected ? .white : .green
            )
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .padding(.horizontal, 4)
    }
}

extension ButtonStyle where Self == TimeframeButtonStyle {
    static func timeframe(isSelected: Bool) -> TimeframeButtonStyle {
        TimeframeButtonStyle(isSelected: isSelected)
    }
}

extension ButtonStyle where Self == DismissCrownButtonStyle {
    static var dismissCrownButtonStyle: DismissCrownButtonStyle { DismissCrownButtonStyle() }
}

#Preview {
    VStack {

        Button("Test"){

        }
        .buttonStyle(.dismissCrownButtonStyle)
        
        Button("1M"){

        }
        .buttonStyle(.timeframe(isSelected: true))
        
        
        Button("1M"){

        }
        .buttonStyle(.timeframe(isSelected: false))

    }
}


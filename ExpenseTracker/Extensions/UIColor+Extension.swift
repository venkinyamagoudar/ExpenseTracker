//
//  UIColor+Extension.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

extension Color {
    static let darkPurple = Color(red: 0.988235353956, green: 0.815686334348, blue: 0.623529411765, opacity: 1)
}

extension Color {
    static func fromRGBA(_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> Color {
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}

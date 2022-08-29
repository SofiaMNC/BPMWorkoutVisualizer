//
//  ColorPalette.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

enum ColorPalette {
    enum Global {
        static let neutral: UIColor = assetColor(named: "NeutralColor") ?? .white
        static let inactive: UIColor = assetColor(named: "InactiveColor") ?? .gray
    }

    static func assetColor(named colorName: String) -> UIColor? {
        guard let color = UIColor(named: colorName) else {
            assertionFailure("Requested color named \(colorName) is undefined.")
            return nil
        }
        return color
    }
}

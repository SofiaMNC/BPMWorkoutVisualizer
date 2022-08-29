//
//  UILabel+Extension.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

extension UILabel {
    static func makeDefaultLabel(textStyle: UIFont.TextStyle, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true
        return label
    }
}

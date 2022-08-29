//
//  MiniDateLabel.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

/// A view presenting a date in a very short format
/// - the day of the week
/// - the day number
class MiniDateLabel: UILabel {
    // MARK: Lifecycle

    init(date: Date) {
        self.date = date

        super.init(frame: .zero)

        numberOfLines = 2
        font = .preferredFont(forTextStyle: .title3)
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        allowsDefaultTighteningForTruncation = true
        textAlignment = .center
        text = formatted(date)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    /// Accessor for the date backing the view.
    /// It is automatically formatted for display.
    var date: Date {
        didSet {
            text = formatted(date)
        }
    }

    // MARK: Private

    private enum Constant {
        enum Dimension {
            static let size = 50
        }

        enum DateFormat {
            static let miniDay = "E \nd"
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.DateFormat.miniDay
        return formatter.string(from: date)
    }
}

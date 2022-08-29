//
//  DetailedTextView.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

/// A view presenting a text summary of an activity
/// It includes 3 hierarchized textfields
class DetailedTextView: UIStackView {
    // MARK: Lifecycle

    init(
        title: String,
        subtitle: String,
        details: NSAttributedString
    ) {
        // workaround since `super.init(arrangedSubviews: self.floatingButtons)`
        // can not currently be used because of an acknowledged bug in
        // Apple's `UIStackView` marked as "believed fixed" as of iOS 10,
        // but crashing on iOS 15.
        // See: https://stackoverflow.com/q/36502790/12470530 and http://www.openradar.me/radar?id=4989179939258368
        super.init(frame: .zero)
        [titleLabel, subtitleLabel, detailsLabel].forEach { addArrangedSubview($0) }

        axis = .vertical

        self.title = title
        self.subtitle = subtitle
        self.details = details
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    /// Global color for the view
    /// If the inner views have different colors, this property returns `nil`
    /// as there is no global color set.
    var textColor: UIColor? {
        get {
            guard
                Set([
                    titleLabel.textColor,
                    subtitleLabel.textColor,
                    detailsLabel.textColor,
                ]).count == 1
            else {
                return nil
            }

            return titleLabel.textColor
        }

        set {
            [titleLabel, subtitleLabel, detailsLabel].forEach { $0.textColor = newValue }
        }
    }

    /// Accessor for the `titleLabel`'s text
    var title: String? {
        get {
            titleLabel.text
        }

        set {
            titleLabel.text = newValue
        }
    }

    /// Accessor for the `subtitleLabel`'s text
    var subtitle: String? {
        get {
            subtitleLabel.text
        }

        set {
            subtitleLabel.text = newValue
        }
    }

    /// Accessor for the `detailsLabel`'s text
    var details: NSAttributedString? {
        get {
            detailsLabel.attributedText
        }

        set {
            detailsLabel.attributedText = newValue
        }
    }

    // MARK: Private

    private let titleLabel: UILabel = {
        let label = UILabel.makeDefaultLabel(textStyle: .title1)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel.makeDefaultLabel(textStyle: .title2)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let detailsLabel = UILabel.makeDefaultLabel(textStyle: .title2, numberOfLines: 2)
}

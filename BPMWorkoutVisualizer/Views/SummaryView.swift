//
//  SummaryView.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import SnapKit
import UIKit

/// A view presenting a condensed summary of an activity
/// It includes:
/// - a date
/// - 3 hierarchized textfields
/// - 1 illustration
class SummaryView: UIStackView {
    // MARK: Lifecycle

    init(
        color: UIColor,
        miniDateLabel: MiniDateLabel,
        detailedTextView: DetailedTextView,
        illustration: UIImage?
    ) {
        self.miniDateLabel = miniDateLabel
        self.detailedTextView = detailedTextView

        // workaround since `super.init(arrangedSubviews: self.floatingButtons)`
        // can not currently be used because of an acknowledged bug in
        // Apple's `UIStackView` marked as "believed fixed" as of iOS 10,
        // but crashing on iOS 15.
        // See: https://stackoverflow.com/q/36502790/12470530 and http://www.openradar.me/radar?id=4989179939258368
        super.init(frame: .zero)
        [miniDateLabel, separatorLine, detailedTextView, illustrationView].forEach { addArrangedSubview($0) }

        axis = .horizontal
        spacing = Constant.Dimension.contentStackViewSpacing

        self.color = color
        self.illustration = illustration

        setUpViews()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    /// Global color for the view
    /// If the inner views have different colors, this property returns `nil`
    /// as there is no global color set.
    var color: UIColor? {
        get {
            guard
                Set([
                    miniDateLabel.textColor,
                    detailedTextView.textColor,
                    illustrationView.tintColor,
                    separatorLine.backgroundColor,
                ]).count == 1
            else {
                return nil
            }

            return miniDateLabel.textColor
        }

        set {
            miniDateLabel.textColor = newValue
            detailedTextView.textColor = newValue
            illustrationView.tintColor = newValue
            separatorLine.backgroundColor = newValue
        }
    }

    /// Accessor for the `miniDateLabel`'s text
    var formattedDate: String? {
        get {
            miniDateLabel.text
        }

        set {
            miniDateLabel.text = newValue
        }
    }

    /// Accessor for the `detailedTextView`'s title
    var title: String? {
        get {
            detailedTextView.title
        }

        set {
            detailedTextView.title = newValue
        }
    }

    /// Accessor for the `detailedTextView`'s subtitle
    var subtitle: String? {
        get {
            detailedTextView.subtitle
        }

        set {
            detailedTextView.subtitle = newValue
        }
    }

    /// Accessor for the `detailedTextView`'s details
    var details: NSAttributedString? {
        get {
            detailedTextView.details
        }

        set {
            detailedTextView.details = newValue
        }
    }

    /// Accessor for the `illustrationView`'s image
    var illustration: UIImage? {
        get {
            illustrationView.image
        }

        set {
            illustrationView.image = newValue
        }
    }

    // MARK: Private

    private enum Constant {
        enum Dimension {
            static let contentStackViewSpacing: CGFloat = 10
            static let illustrationViewWidth = 50
            static let miniDateLabelWidth = 50
            static let separatorLineWidth = 1
        }
    }

    private let miniDateLabel: MiniDateLabel
    private let separatorLine = UIView()
    private let detailedTextView: DetailedTextView

    private let illustrationView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private func setUpViews() {
        miniDateLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.Dimension.miniDateLabelWidth)
        }

        separatorLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(Constant.Dimension.separatorLineWidth)
        }

        illustrationView.snp.makeConstraints { make in
            make.width.equalTo(Constant.Dimension.illustrationViewWidth)
        }
    }
}

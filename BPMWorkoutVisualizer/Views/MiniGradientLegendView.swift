//
//  LegendView.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

/// An entity to create a minimalist gradient legend with bounds
/// and an illustration to clarify the meaning of the values represented
class MiniGradientLegendView: UIStackView {
    init(lowestValue: Int, gradientColors: [UIColor], highestValue: Int, illustration: UIImage?, illustrationTintColor: UIColor?) {
        self.lowestValue = lowestValue
        self.highestValue = highestValue
        self.gradientColors = gradientColors
        self.illustration = illustration
        self.illustrationTintColor = illustrationTintColor

        // workaround since `super.init(arrangedSubviews: self.floatingButtons)`
        // can not currently be used because of an acknowledged bug in
        // Apple's `UIStackView` marked as "believed fixed" as of iOS 10,
        // but crashing on iOS 15.
        // See: https://stackoverflow.com/q/36502790/12470530 and http://www.openradar.me/radar?id=4989179939258368
        super.init(frame: .zero)
        [illustrationView, lowestValueLabel, gradientView, highestValueLabel].forEach { addArrangedSubview($0) }

        axis = .horizontal
        spacing = Constant.spacing
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var lowestValue: Int
    var highestValue: Int
    var gradientColors: [UIColor]
    var illustration: UIImage?
    var illustrationTintColor: UIColor?

    private lazy var illustrationView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = illustration
        imageView.tintColor = illustrationTintColor
        return imageView
    }()

    private lazy var lowestValueLabel: UILabel = {
        let label = UILabel.makeDefaultLabel(textStyle: .caption1)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.text = String(lowestValue)
        label.textColor = ColorPalette.Global.inactive
        return label
    }()

    private lazy var gradientView = GradientView(isHorizontal: true, colors: gradientColors.map(\.cgColor))

    private lazy var highestValueLabel: UILabel = {
        let label = UILabel.makeDefaultLabel(textStyle: .caption1)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.text = String(highestValue)
        label.textColor = ColorPalette.Global.inactive
        return label
    }()

    private enum Constant {
        static let spacing: CGFloat = 10
    }
}

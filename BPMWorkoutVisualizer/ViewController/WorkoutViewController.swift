//
//  WorkoutViewController.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import MapKit

// MARK: - WorkoutViewController

class WorkoutViewController: UIViewController {
    // MARK: Internal

    var workout = Workout.makeSampleWorkout()

    lazy var workoutSummaryView: SummaryView = {
        let summaryView = SummaryView(
            color: ColorPalette.Global.inactive,
            miniDateLabel: MiniDateLabel(date: workout.startDate),
            detailedTextView: DetailedTextView(
                title: workout.title,
                subtitle: workout.subtitle,
                details: makeDurationText(for: workout.duration)
            ),
            illustration: UIImage(systemName: Constant.Image.workoutValidated)
        )

        summaryView.isAccessibilityElement = true
        summaryView.accessibilityLabel = makeAccessibilityLabel(for: workout)

        return summaryView
    }()

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()

    lazy var legendContainerView: UIView = {
        let legendContainerView = UIView()
        legendContainerView.backgroundColor = ColorPalette.Global.neutral

        /// Rounding top and bottom left corners
        legendContainerView.layer.cornerRadius = Constant.Dimension.HeartRateLegend.cornerRadius
        legendContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]

        /// Adding shadow to increase visibility
        legendContainerView.layer.shadowColor = ColorPalette.Global.inactive.cgColor
        legendContainerView.layer.shadowOpacity = Constant.Dimension.HeartRateLegend.shadowOpacity
        legendContainerView.layer.shadowOffset = .zero
        legendContainerView.layer.shadowRadius = Constant.Dimension.HeartRateLegend.shadowRadius

        return legendContainerView
    }()

    lazy var heartRateLegend: MiniGradientLegendView = {
        let heartRates = workout.data.map(\.heartRate)

        return MiniGradientLegendView(
            lowestValue: heartRates.min() ?? 0,
            gradientColors: heartRateColors,
            highestValue: heartRates.max() ?? 0,
            illustration: UIImage(systemName: Constant.Image.heartRateLegend)?.withTintColor(.red),
            illustrationTintColor: .red
        )
    }()

    let heartRateColors: [UIColor] = [.green, .yellow, .orange, .red]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MY WORKOUT"
        view.backgroundColor = ColorPalette.Global.neutral

        setUpViews()
        plotRoute()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            workoutSummaryView.details = makeDurationText(for: workout.duration)
            view.layoutIfNeeded()
        }
    }

    // MARK: Private

    private enum Constant {
        enum Dimension {
            enum WorkoutSumamryView {
                static let inset = 10
                static let minimumHeight = 100
            }

            enum MapView {
                static let offsetTop: Double = 10
            }

            enum HeartRateLegend {
                static let size = CGSize(width: 200, height: 30)
                static let trailingInset = 10
                static let innerInset = 10
                static let cornerRadius: CGFloat = 15
                static let shadowOpacity: Float = 1
                static let shadowRadius: CGFloat = 5
            }
        }

        enum Image {
            static let duration = "timer"
            static let workoutValidated = "checkmark.circle.fill"
            static let heartRateLegend = "heart.fill"
        }
    }

    private func makeAccessibilityLabel(for workout: Workout) -> String {
        /// Accessibility title - stripping final emoji
        var accessibilityWorkoutTitle = workout.title
        accessibilityWorkoutTitle = String(accessibilityWorkoutTitle.dropLast())

        /// Accessibility date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d"
        let accessibilityWorkoutDate = formatter.string(from: workout.startDate)

        /// Accessibility duration
        var accessibilityDurationComponents: [String] = []
        let durationComponents = durationComponents(for: workout.duration)

        [
            (component: durationComponents.hours, singular: "hour", plural: "hours"),
            (component: durationComponents.minutes, singular: "minute", plural: "minutes"),
            (component: durationComponents.seconds, singular: "second", plural: "seconds"),
        ].forEach { durationComponent in
            if durationComponent.component != 0 {
                let timeUnit = durationComponent.component == 1 ? durationComponent.singular : durationComponent.plural
                accessibilityDurationComponents.append("\(durationComponent.component) \(timeUnit)")
            }
        }

        let accessibilityDurationString = accessibilityDurationComponents.joined(separator: ",")

        return """
        Summary of my \(accessibilityWorkoutTitle) workout, from \(accessibilityWorkoutDate).
        I trained for \(accessibilityDurationString).
        My workout's secondary activity was to \(workout.subtitle).
        """
    }

    private func setUpViews() {
        view.addSubview(workoutSummaryView)
        workoutSummaryView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(Constant.Dimension.WorkoutSumamryView.minimumHeight)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constant.Dimension.WorkoutSumamryView.inset)
        }

        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(workoutSummaryView.snp.bottom).offset(Constant.Dimension.MapView.offsetTop)
        }

        view.addSubview(legendContainerView)
        legendContainerView.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(Constant.Dimension.HeartRateLegend.size)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.Dimension.HeartRateLegend.trailingInset)
            make.trailing.equalToSuperview()
        }

        legendContainerView.addSubview(heartRateLegend)
        heartRateLegend.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.Dimension.HeartRateLegend.innerInset)
        }
    }

    /// Creates a text displaying a timer icon followed by the duration of the workout
    /// - Parameter workoutDuration: the duration of the workout
    /// - Returns the properly formatted `NSAttributedString`
    private func makeDurationText(for workoutDuration: Double) -> NSAttributedString {
        let attachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        attachment.image = UIImage(systemName: Constant.Image.duration, withConfiguration: config)?.withTintColor(ColorPalette.Global.inactive)
        let imageString = NSMutableAttributedString(attachment: attachment)

        let durationComponents = durationComponents(for: workoutDuration)
        let durationString = [
            durationComponents.hours,
            durationComponents.minutes,
            durationComponents.seconds,
        ].map { String(format: "%02d", $0) }.joined(separator: " : ")
        let textString = NSAttributedString(string: " \(durationString)")

        imageString.append(textString)

        return imageString
    }

    private func durationComponents(for workoutDuration: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        return (
            Int(workoutDuration / 3600),
            (Int(workoutDuration) % 3600) / 60,
            (Int(workoutDuration) % 3600) % 60
        )
    }
}

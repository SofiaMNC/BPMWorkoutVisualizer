//
//  WorkoutViewController.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MY WORKOUT"
        view.backgroundColor = ColorPalette.Global.neutral

        setUpViews()
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
        }

        enum Image {
            static let duration = "timer"
            static let workoutValidated = "checkmark.circle.fill"
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

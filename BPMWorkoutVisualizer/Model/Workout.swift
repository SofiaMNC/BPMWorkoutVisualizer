//
//  Workout.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import Foundation

/// An entity representing a workout
struct Workout {
    let title: String
    let subtitle: String
    let type: WorkoutType
    let startDate: Date
    let endDate: Date?

    /// The data points gathered during the workout
    let data: [WorkoutDataPoint]

    /// The duration of the workout in seconds.
    /// If an end date is provided, it is calculated using the start and end date.
    /// Otherwise, it is inferred from the number of data points.
    var duration: Double {
        if let endDate = endDate {
            return endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        } else {
            return Double((data.count / WorkoutDataPoint.defaultFrequency) * 60)
        }
    }

    static func makeSampleWorkout() -> Workout {
        let workoutSampleURL = Bundle.main.url(
            forResource: "latitude_longitude_heartrate",
            withExtension: "json"
        )

        return Workout(
            title: "Outdoor Running 👟",
            subtitle: "Stretch",
            type: .running,
            startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            endDate: nil,
            data: fetchSampleWorkoutData(at: workoutSampleURL)
        )
    }

    private static func fetchSampleWorkoutData(at workoutSampleURL: URL?) -> [WorkoutDataPoint] {
        do {
            return try JSONRepository<WorkoutDataPoint>(fileURL: workoutSampleURL).list() ?? []
        } catch {
            assertionFailure("Decoding error = \(String(describing: error))")
            return []
        }
    }
}

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
}

//
//  WorkoutDataPoint.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import Foundation
import MapKit

/// An entity representing a workout data point
struct WorkoutDataPoint: Decodable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let expectedRawDataPointSize = 3
        var rawDataPoint: [Double] = []

        while !container.isAtEnd {
            rawDataPoint.append(try container.decode(Double.self))
        }

        guard rawDataPoint.count == expectedRawDataPointSize else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: """
                    Array has wrong number of values: \
                    expected \(expectedRawDataPointSize), \
                    got \(rawDataPoint.count) instead.
                    """
                ))
        }

        position = CLLocationCoordinate2D(latitude: rawDataPoint[0], longitude: rawDataPoint[1])
        heartRate = Int(rawDataPoint[2])
    }

    // MARK: Internal

    /// The number of data points per minute
    static var defaultFrequency = 5

    /// A 2D position with latitude and longitude
    let position: CLLocationCoordinate2D

    /// A heart rate in beats per minute
    let heartRate: Int
}

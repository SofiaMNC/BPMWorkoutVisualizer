//
//  BPMWorkoutVisualizerTests.swift
//  BPMWorkoutVisualizerTests
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

@testable import BPMWorkoutVisualizer
import XCTest

final class JSONRepositoryTests: XCTestCase {
    var sut: JSONRepository<WorkoutDataPoint>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = JSONRepository<WorkoutDataPoint>()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - Fade Out Duration

    func test_list_givenValidInput_returnsCorrectResult() throws {
        // given a valid sample JSON file containing workout data points
        let expectedNumberOfWorkoutDataPoints = 2
        sut.fileURL = Bundle(for: type(of: self)).url(forResource: "valid_workout_data_points_sample", withExtension: "json")

        // when listing the data
        let workoutDataPoint = try? sut.list()

        // then
        guard let workoutDataPoint = workoutDataPoint else {
            XCTFail("""
            \(expectedNumberOfWorkoutDataPoints) workout data points were expected, \
            no data was retrieved.
            """)
            return
        }

        XCTAssertEqual(
            workoutDataPoint.count,
            expectedNumberOfWorkoutDataPoints,
            """
            Incorrect number of workout data points retrieved. \
            Expected \(expectedNumberOfWorkoutDataPoints), \
            got \(workoutDataPoint.count) instead.
            """
        )
    }

    func test_list_givenInvalidData_failsToDecode() throws {
        // given a sample JSON file containing invalid workout data points
        sut.fileURL = Bundle(for: type(of: self)).url(forResource: "invalid_workout_data_points_sample", withExtension: "json")

        // when listing the data
        XCTAssertThrowsError(
            try sut.list(),
            "The data contained invalid data points. An error should have been thrown."
        )
    }

    func test_list_givenInvalidFormat_failsToDecode() throws {
        // given a sample JSON file containing invalid JSON
        sut.fileURL = Bundle(for: type(of: self))
            .url(forResource: "invalid_json_format_workout_data_points_sample", withExtension: "json")

        // when listing the data
        XCTAssertThrowsError(
            try sut.list(),
            "The data contained invalid json. An error should have been thrown."
        )
    }
}

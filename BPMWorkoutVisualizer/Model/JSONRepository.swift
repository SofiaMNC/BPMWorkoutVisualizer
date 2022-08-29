//
//  JSONRepository.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import Foundation

/// A generic repository for JSON encoded data
struct JSONRepository<StoredType: Decodable>: Repository {
    // MARK: Internal

    typealias T = StoredType

    init(fileURL: URL? = nil) {
        self.fileURL = fileURL
    }

    /// The URL at which the data is stored
    var fileURL: URL?

    /// Adds data to the store.
    /// - Warning: Not implemented
    func add(_: StoredType) throws {
        assertionFailure("Adding json data is not supported at the moment.")
    }

    /// Updates data in the store.
    /// - Warning: Not implemented
    func update(_: StoredType) throws {
        assertionFailure("Updating stored json data is not supported at the moment.")
    }

    /// Gets one specific data point from the store.
    /// - Parameter id: the data point's identifier.
    /// - Warning: Not implemented
    func get(id _: Int) -> StoredType? {
        assertionFailure("Getting a specific json data point is not supported at the moment.")
        return nil
    }

    /// Lists data in the store.
    /// - Returns An array of data points
    /// - Throws A decoding array if the JSON file or the data contained is invalid.
    /// - Warning: Not implemented
    func list() throws -> [StoredType]? {
        guard
            let url = fileURL,
            let jsonData = try? Data(contentsOf: url)
        else {
            return nil
        }

        return try decoder.decode([StoredType].self, from: jsonData)
    }

    /// Deletes data from the store.
    /// - Warning: Not implemented
    func delete(_: StoredType) throws {
        assertionFailure("Deleting stored json data is not supported at the moment.")
    }

    // MARK: Private

    private let decoder = JSONDecoder()
}

//
//  Repository.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import Foundation

// MARK: - Repository

/// A protocol to describe methods that any storage entity must implement
protocol Repository {
    associatedtype T

    func add(_ item: T) throws
    func update(_ item: T) throws
    func get(id: Int) -> T?
    func list() throws -> [T]?
    func delete(_ item: T) throws
}

# **📱 BPM Workout Visualizer**
*Sofia Chevrolat (August 2022)*

[![forthebadge](https://forthebadge.com/images/badges/made-with-swift.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)

____


## **✨ Features**
From a JSON file containing workout data points (latitude, longitude, heart rate):
- Visualize a workout summary - _date, title, subtitle and duration of your workout_ - , along with a plot of your route on a map.

- The plot is colored according to your heart rate during the workout. A minimalist legend displays the lowest and highest values.

- Supports: 
    - Accessibility Features:
        - Dynamic Type and Bold Text
        - Voice Over
    - Dark mode


___
## **🔍 Implementation overview**

### _**➡️ Overview**_
- The sample app follows an MVC architecture
- The views have been created to be as reusable as possible
- The `WorkoutDataPoint` struct conforms to `Decodable` and implements a custom `init(from decoder: Decoder) throws`
- The repository pattern is implemented for retrieving stored data, using:
    - a `Repository` protocol
    - a generic `JSONRepository` class that can be used to retrieve any type stored using JSON.

### _**➡️ Programming Concepts and Techniques**_
- MVC architecture
- Repository design pattern
- Protocols
- Generics
- Object Oriented Design (classes, inheritance)
- Composition
- Auto Layout with Safe Area
- Trait Collections
- Accessibiltiy
- Dark mode
- Programmatic UI

### _**➡️ Class Diagram**_

A full class diagram is provided in the _Documentation_ folder. 
Below is a shortened version of the most important entities:

```mermaid
classDiagram

%% ============= ENTITIES ============= %%

%% CLASSES

class WorkoutViewController {
    var workout: Workout
    var workoutSummaryView: SummaryView
    var mapView: MKMapView
    var legendView: LegendView

    func plotRoute()
}

class JSONRepository {
    typealias T = StoredType
    var fileURL: URL?

    add(_: StoredType) throws
    update(_: StoredType) throws
    get(id _: Int) -> StoredType?
    list() throws -> [StoredPoint]?
    delete(_: StoredType) throws
}

%% STRUCTS
class Workout { 
    title: String
    subtitle: String
    type: WorkoutType
    startDate: Date
    endDate: Date?
    duration: Double
    data: [WorkoutDataPoint]
}

class WorkoutDataPoint {
    position: CLLocationCoordinate2D
    heartRate: Int

    init(from decoder: Decoder) throws
}

%% ENUMS
class WorkoutType {
    case running
}

%% PROTOCOL
class Decodable {
    init(from decoder: Decoder) throws
}

class Repository {
    associatedtype T

    func add(_ item: T) throws
    func update(_ item: T) throws
    func get(id: Int) -> T?
    func list() throws -> [T]?
    func delete(_ item: T) throws
}

class MKMapViewDelegate 

%% ========== RELATIONSHIPS ========== %%

WorkoutViewController ..|> MKMapViewDelegate : \nConforms to \n(Conformance)
Workout *-- JSONRepository : \nCreates \n(Composition)
WorkoutViewController "1" *-- "1" Workout : \nCreates \n(Composition)
Workout "1" <.. "1" WorkoutType : \nReceives \n(Dependency)
Workout "1" <.. "1..*" WorkoutDataPoint : \nReceives \n(Dependency)
JSONRepository ..> WorkoutDataPoint : \nFetches
JSONRepository ..|> Repository : \n Conforms to \n(Conformance)
WorkoutDataPoint ..|> Decodable : \n Conforms to \n(Conformance)

```

### _**➡️ Testing**_

The app comes with a few unit tests validating the behavior of the JSONRepository, the key component of the sample app.

___

## **📲 Usage**
### _**Dependencies and Requirements**_

![](https://img.shields.io/badge/iOS-15.5%20or%20greater-brightgreen)
![](https://img.shields.io/badge/SnapKit-v%205.6.0-blueviolet)
![](https://img.shields.io/badge/SwiftFormat-v%200.49.17-cyan)
![](https://img.shields.io/badge/Swift-5%20or%20greater-orange)


The following 2 packages are included:

- [SnapKit](https://github.com/SnapKit/SnapKit) for easy view positioning.
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) for code formatting. Swift format is run at each build and enforces a set of rules declared in the accompanying `.swiftformat` file.

### _**Steps**_
- Open the project in Xcode
- Run "Resolve Package Versions" (_File > Packages_) if needed
- Run the project
    - Try different accessibility font sizes and see the UI update dynamically.
    - Try switching between dark / light mode and see the UI update dynamically.
    - Try using Voice Over to have a human-friendly read of the summary view.
- Run the tests

______
## 📝 Documentation
- Interface functions and variable are documented with DocC style comments.

These can be used to generate a documentation for the app (as of WWDC2022), that can be hosted on GitHub page or on any other website.

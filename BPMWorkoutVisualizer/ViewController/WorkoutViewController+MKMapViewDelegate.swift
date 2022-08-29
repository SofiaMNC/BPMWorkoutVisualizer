//
//  WorkoutViewController+MKMapViewDelegate.swift
//  BPMWorkoutVisualizer
//
//  Created by Sofia Chevrolat on 29/08/2022.
//

import MapKit

// MARK: - customPin

class customPin: NSObject, MKAnnotation {
    // MARK: Lifecycle

    init(location: CLLocationCoordinate2D) {
        coordinate = location
    }

    // MARK: Internal

    var coordinate: CLLocationCoordinate2D
}

// MARK: - WorkoutViewController + MKMapViewDelegate

extension WorkoutViewController: MKMapViewDelegate {
    // MARK: Internal

    /// Creates an overlay of the workout route colored by the heart rate
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myPolyline = overlay as! MKPolyline
        let pointLocations = myPolyline.locations(at: IndexSet(integersIn: 0 ..< workout.data.count))

        let renderer = MKGradientPolylineRenderer(polyline: myPolyline)

        if let colorsForHeartRate = colorsForHeartRate() {
            renderer.setColors(colorsForHeartRate, locations: pointLocations)
        } else {
            renderer.strokeColor = UIColor.systemCyan
        }

        renderer.lineWidth = Constant.Dimension.MapView.plotLineWidth
        return renderer
    }

    /// Creates image annotations.
    /// The last annotation is marked by a different image than the other annotations.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = Constant.Identifier.annotation

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(
                systemName: isEndPoint(annotation: annotation) ? Constant.Image.endPoint : Constant.Image.startPoint)
            annotationView.annotation = annotation
            return annotationView
        }
    }

    /// Plots a workout route colored as a function of the heart rate
    /// and delimited by start and end annotations.
    func plotRoute() {
        guard let startPoint = workout.data.first, let endPoint = workout.data.last else {
            return
        }

        mark(workoutPoint: startPoint)
        traceRoute(for: workout.data.map(\.position))
        mark(workoutPoint: endPoint)
    }

    // MARK: Private

    private enum Constant {
        enum Dimension {
            enum MapView {
                static let plotLineWidth: CGFloat = 3
                static let offsetX: Double = 500
                static let offsetWidth: Double = 900
            }
        }

        enum Identifier {
            static let annotation = "EndPointPin"
        }

        enum Image {
            static let startPoint = "hare.fill"
            static let endPoint = "flag.fill"
        }
    }

    private func mark(workoutPoint: WorkoutDataPoint) {
        mapView.addAnnotation(customPin(location: workoutPoint.position))
    }

    private func traceRoute(for coordinates: [CLLocationCoordinate2D]) {
        let workoutPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(workoutPolyline)
        centerMapView(around: workoutPolyline)
    }

    private func centerMapView(around polyline: MKPolyline) {
        let rect = polyline.boundingMapRect
        let largerRect = MKMapRect(
            origin: MKMapPoint(x: rect.origin.x - Constant.Dimension.MapView.offsetX, y: rect.origin.y),
            size: MKMapSize(width: rect.size.width + Constant.Dimension.MapView.offsetWidth, height: rect.size.height)
        )
        mapView.setRegion(MKCoordinateRegion(largerRect), animated: true)
    }

    private func isEndPoint(annotation: MKAnnotation) -> Bool {
        guard let lastAnnotation = workout.data.last?.position else {
            return false
        }

        return annotation.coordinate.latitude == lastAnnotation.latitude &&
            annotation.coordinate.longitude == lastAnnotation.longitude
    }

    /// Attributes a color for each data point depending on the value of
    /// the heart rate.
    /// The colors are based on quartiles calculated based on the lowest
    /// and the highest heart rate values
    private func colorsForHeartRate() -> [UIColor]? {
        let heartRates = workout.data.map(\.heartRate)

        guard
            let minHeartRate = heartRates.min(),
            let maxHeartRate = heartRates.max()
        else {
            assertionFailure("The heart rates array seems invalid. Min / max returned nil.")
            return nil
        }

        guard heartRateColors.count == 4 else {
            assertionFailure("Expected 4 heart rate colors, got \(heartRateColors.count) instead.")
            return nil
        }

        let step = (maxHeartRate - minHeartRate) / heartRateColors.count

        return heartRates.map { heartRate in
            switch heartRate {
            case minHeartRate ..< (minHeartRate + step):
                return heartRateColors[0]
            case minHeartRate + step ..< (minHeartRate + 2 * step):
                return heartRateColors[1]
            case minHeartRate + 2 * step ..< (minHeartRate + 3 * step):
                return heartRateColors[2]
            case minHeartRate + 3 * step ... maxHeartRate:
                return heartRateColors[3]
            default:
                assertionFailure("Color for heart rate calculations invalid. One heart rate value is out of bounds.")
                return UIColor.black
            }
        }
    }
}

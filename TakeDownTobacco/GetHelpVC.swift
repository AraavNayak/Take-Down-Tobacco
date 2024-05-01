////
////  GetHelpVC.swift
////  TakeDownTobacco
////
////  Created by Araav Nayak on 4/20/24.
////

import UIKit
import MapKit

class GetHelpVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directions: UITextView!
    var locationManager: CLLocationManager!
    var selectedHospital: MKMapItem?
    var myGeoCoder = CLGeocoder()
    var distance = 0
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientView()
        
        directions.backgroundColor = UIColor.black
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hospital"
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error searching for hospitals: \(error)")
                }
                return
            }
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.1) // Blue fill color with transparency
            renderer.strokeColor = UIColor.blue // Border color
            renderer.lineWidth = 1
            return renderer
        }
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
        renderer.lineWidth = 5
        return renderer
    }
    
    func findNearby(str: String) -> MKMapItem {
        let mySearchReq = MKLocalSearch.Request()
        mySearchReq.naturalLanguageQuery = str
        mySearchReq.region = self.mapView.region
        var myMapItem: MKMapItem = MKMapItem()
        
        let localSearch = MKLocalSearch(request: mySearchReq)
        localSearch.start(completionHandler: {
            searchResponse, searchError in
            
            if searchError != nil {
                print(searchError!)
                return
            }
            
            let myMapItems = searchResponse!.mapItems as [MKMapItem]
            myMapItem = myMapItems[0]
        })
        return myMapItem
    }
    
    func getRoute(toMapItem: MKMapItem) {
        let dirReq = MKDirections.Request()
        let transType = MKDirectionsTransportType.automobile
        var myRoute: MKRoute?
        var showRoute = ""
        
        dirReq.destination = toMapItem
        dirReq.transportType = transType
        
        let myDirections = MKDirections(request: dirReq) as MKDirections
        myDirections.calculate(completionHandler: {
            routeResponse, routeError in
            
            if routeError != nil {
                print(routeError!)
                return
            }
            
            myRoute = routeResponse?.routes[0] as MKRoute?
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay((myRoute?.polyline)!, level: MKOverlayLevel.aboveRoads)
            
            var number = (myRoute?.distance)!/1609
            //self.distanceLabel.text = String(format: "%.2f", number)
            
            if let steps = myRoute?.steps as [MKRoute.Step]? {
                for step in steps {
                    showRoute = showRoute + step.instructions + "\n"
                }
                self.directions.text = showRoute
            } else {
            }
        })
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            selectedHospital = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
            locationManager.startUpdatingLocation() // Trigger route calculation
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        //        let userCircle = MKCircle(center: userLocation.coordinate, radius: 100) // You can adjust the radius as needed
        //        mapView.addOverlay(userCircle)
        let userPlacemark = MKPointAnnotation()
        userPlacemark.coordinate = userLocation.coordinate
        userPlacemark.title = "Your Location"
        
        // Add the placemark to the map
        mapView.addAnnotation(userPlacemark)
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000) // Adjust the values as needed
        
        // Set the region on the map view
        mapView.setRegion(region, animated: true)
    
        // Create a placemark for the user's location
//        let userPlacemark = MKPointAnnotation()
//        userPlacemark.coordinate = userLocation.coordinate
//        userPlacemark.title = "Your Location"
//        
//        // Add the placemark to the map
//        mapView.addAnnotation(userPlacemark)
//        
//        if let annotationView = mapView.view(for: userPlacemark) {
//            annotationView.tintColor = UIColor.blue // Set the color to blue
//        }}
        
        if let selectedHospital = selectedHospital {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            request.destination = selectedHospital
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if let error = error {
                    print("Error calculating directions: \(error)")
                    return
                }
                
                guard let response = response else {
                    print("No response received.")
                    return
                }
                
                guard let route = response.routes.first else {
                    print("No routes found.")
                    return
                }
                
                
                // Clear existing overlays
                self.mapView.removeOverlays(self.mapView.overlays)
                self.directions.text = ""
                //var totalDistance: CLLocation
                self.distance = 0
                self.destinationLabel.text = "Destination: "
                
                // Add new overlay
                //self.destinationLabel.text =
                
                let location = CLLocation(latitude: selectedHospital.placemark.coordinate.latitude, longitude: selectedHospital.placemark.coordinate.longitude)
                let geocoder = CLGeocoder()
                    
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    guard let placemark = placemarks?.first, error == nil else {
                        print("Reverse geocoding failed with error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    if let streetAddress = placemark.thoroughfare {
                        self.destinationLabel.text = "Destination: " + streetAddress + " " + placemark.postalCode!
                    } else {
                        print("Street address not found.")
                    }
                }
                
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                // Print each step in the directions
                for step in route.steps {
                    self.directions.text = self.directions.text + step.instructions + "\n"
                    self.distance += Int(step.distance)
                    //print(step.instructions)
                }
                self.distanceLabel.text = "\(((self.metersToMiles(CLLocationDistance(self.distance))) * 100).rounded() / 100) miles"
            }
            
        
            
            
            
            
        }
    }

    private func setupGradientView() {
        let gradientView = GradientViewII(frame: view.bounds)
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
    }
    
    

    func metersToMiles(_ meters: CLLocationDistance) -> Double {
        // 1 meter is approximately 0.000621371 miles
        let conversionFactor = 0.000621371
        return meters * conversionFactor
    }
    
    
}


class GradientViewII: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    private func setupGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            fatalError("Unable to access gradient layer")
        }
        gradientLayer.colors = [UIColor.black.cgColor, UIColor(red: 34/255, green: 17/255, blue: 77/255, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
}
        
    
    



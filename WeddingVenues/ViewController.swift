//
//  ViewController.swift
//  WeddingVenues
//
//  Created by Lauren Nicole Roth on 3/13/17.
//  Copyright © 2017 Lauren Nicole Roth. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AlecrimCoreData

class ViewController: UIViewController {
    
    var venues = [
        (name: "Degas House", address: "2306 Esplanade Ave, New Orleans, LA 70119", district: "7th Ward"),
        (name: "Benachi House", address: "2257 Bayou Rd, New Orleans, LA 70119", district: "7th Ward"),
    ]

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.0
    
    var selectedPlace: GMSPlace?
    let startingPoint = CLLocationCoordinate2DMake(29.9296667, -90.0911728)
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    let venueManager = WeddingVenueManager.sharedInstance
    
    var venuePlaces: [GMSPlace] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        getVenues()
        
        let camera = GMSCameraPosition.camera(withLatitude: startingPoint.latitude,
                                              longitude: startingPoint.longitude,
                                              zoom: zoomLevel)
        
        mapView.animate(to: camera)

        let marker = GMSMarker()
        marker.position = startingPoint
        marker.title = "The Elms Mansion"
        marker.map = mapView

    }
    
    func getVenues() {
        print("Getting Venues")
        let manager = WeddingVenueManager.sharedInstance
        print("Venue count: ", manager.weddingVenues.count)
        
        for venue in venueManager.weddingVenues {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(venue.latitude, venue.longitude)
            marker.title = venue.name
            marker.snippet = venue.address
            marker.map = mapView
        }
    }
    
    func addMarkerToMap(place: GMSPlace) {
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.title = place.name
        marker.map = mapView
    }
    
    func setupMap() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    @IBAction func addAVenueTouched(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    func listLikelyPlaces() {
        
    }
 
}

extension ViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
   
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        // TODO: Add code to get address components from the selected place.
        let manager = WeddingVenueManager.sharedInstance
        manager.addVenue(place: place)
        
        getVenues()
        
        addMarkerToMap(place: place)
        
        // Close the autocomplete widget.
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//
//  Set.swift
//  iProceed
//
//  Created by Apple Mac on 9/12/2021.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SetLocationView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // variables
    let locationManager = CLLocationManager()
    let myPin = MKPointAnnotation()
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveLocationButton: UIButton!
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveLocationButton.isEnabled = false
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SetLocationView.handleTap(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SecondModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // protocols
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            
            pinAnnotationView.tintColor = UIColor(named: "accentColor")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }
    
    // methods
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.state != UITapGestureRecognizer.State.began{
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            saveLocationButton.isEnabled = true
            
            print("Tapped at Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude))
            
            myPin.coordinate = locationCoordinate
            
            myPin.title = "Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude)
            
            mapView.addAnnotation(myPin)
        }
    }
    
    // actions
    @IBAction func addUserLocation(_ sender: Any) {
        UserViewModel().getUserFromToken() { [self] success, user in
            if success {
                UserViewModel().setLocation(email: (user?.email)!, latitude: myPin.coordinate.latitude, longitude: myPin.coordinate.longitude, clear: false) { success in
                    if success {
                        let action = UIAlertAction(title: "Proceed", style: .default) { uiAction in
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Location saved !", action: action),animated: true)
                    } else {
                        self.present(Alert.makeAlert(titre: "Error", message: "Could not save location"),animated: true)
                    }
                }
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not retrieve user from token"),animated: true)
            }
        }
    }
}

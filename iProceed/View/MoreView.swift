//
//  MoreView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import MapKit
import CoreLocation

class MoreView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    // variables
    let locationManager = CLLocationManager()
    var activeUser : User?
    var currentLocation : CLLocationCoordinate2D?
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var continueWithPaymentButton: UIButton!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continueWithPaymentSegue"{
            let destination = segue.destination as! FaceIdView
            destination.userToBePaid = activeUser
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueWithPaymentButton.isEnabled = false
        
        initializeLocations()
        
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
        
        mapView.showsUserLocation = true
    }
    
    // methods
    func initializeLocations() {
        
        UserViewModel().getAllInstructors{ success, users in
            if success {
                var pinAnnotations : [PinAnnotation] = []
                for user in users! {
                    if !user.latitude!.isEmpty || !user.longitude!.isEmpty {
                        print("Loading location with coordinates (" + String(user.latitude!) + "," + String(user.longitude!) + ")")
                        
                        let pinAnnotation = PinAnnotation()
                        pinAnnotation.setCoordinate(newCoordinate:
                                                        CLLocationCoordinate2D(
                                                            latitude: Double(user.latitude!)!,
                                                            longitude: Double(user.longitude!)!
                                                        ))
                        pinAnnotation.title = user.name
                        pinAnnotation.id = user._id
                        
                        pinAnnotations.append(pinAnnotation)
                    }
                }
                self.mapView.addAnnotations(pinAnnotations)
                
            } else {
                self.present(Alert.makeAlert(titre: "Server error", message: "Could not load locations"),animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pinAnnotation = view.annotation as? PinAnnotation
        
        UserViewModel().getUserById(_id: pinAnnotation?.id) { success, responseUser in
            if success {
                self.activeUser = responseUser
                self.continueWithPaymentButton.isEnabled = true
                self.mapView.delegate = self
                
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load user"), animated: true)
            }
        }
    }
    
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
    
    // actions
    @IBAction func continueWithPayment(_ sender: Any) {
        performSegue(withIdentifier: "continueWithPaymentSegue", sender: activeUser)
    }
}

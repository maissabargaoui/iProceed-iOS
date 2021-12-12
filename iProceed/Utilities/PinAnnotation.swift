//
//  PinAnnotation.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import MapKit

class PinAnnotation : NSObject, MKAnnotation {
    
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var _id : String = String("")
    private var _title: String = String("")
    private var _subtitle: String = String("")
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
    
    var id: String? {
        get {
            return _id
        }
        set (value) {
            self._id = value!
        }
    }
    
    var title: String? {
        get {
            return _title
        }
        set (value) {
            self._title = value!
        }
    }
    
    var subtitle: String? {
        get {
            return _subtitle
        }
        set (value) {
            self._subtitle = value!
        }
    }
}

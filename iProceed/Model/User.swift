//
//  User.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct User: Encodable {
    
    internal init(_id: String? = nil, name: String? = nil, email: String? = nil, address: String? = nil, latitude: String? = nil, longitude: String? = nil, password: String? = nil, phone: String? = nil, role: String? = nil, isVerified: Bool? = nil, typeInstructeur: String? = nil, prixParCour: Float? = nil, neverNotified: Bool? = nil, coursNotifications: [String]? = nil) {
        self._id = _id
        self.name = name
        self.email = email
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.password = password
        self.phone = phone
        self.role = role
        self.isVerified = isVerified
        self.typeInstructeur = typeInstructeur
        self.prixParCour = prixParCour
        self.neverNotified = neverNotified
        self.coursNotifications = coursNotifications
    }

    var _id : String?
    var name : String?
    var email : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var password : String?
    var phone : String?
    var role : String?
    var isVerified : Bool?
    var typeInstructeur: String?
    var prixParCour: Float?
    var neverNotified: Bool?
    var coursNotifications: [String]?
}

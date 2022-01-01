//
//  Course.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation

struct Course : Encodable {
    
    internal init(_id: String? = nil, title: String? = nil, description: String? = nil, date: Date? = nil, user: User? = nil, idPhoto: String? = nil) {
        self._id = _id
        self.title = title
        self.description = description
        self.date = date
        self.user = user
        self.idPhoto = idPhoto
    }
    
    var _id : String?
    var title : String?
    var description : String?
    var date : Date?
    var user : User?
    var idPhoto : String?
    
    
}

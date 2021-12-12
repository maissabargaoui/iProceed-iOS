//
//  Favorite.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation

struct Favorite : Encodable {
    
    internal init(_id: String? = nil, date: Date, user: User, course: Course) {
        self._id = _id
        self.date = date
        self.user = user
        self.course = course
    }
    
    
    var _id : String?
    var date : Date
    
    var user : User
    var course : Course
    
}

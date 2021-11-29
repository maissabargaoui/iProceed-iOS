

import Foundation

struct User: Encodable {
    
    var _id : String?
    var name : String?
    var email : String?
    var address : String?
    var password : String?
    var phone : String?
    var role : String?
    var isVerified : Bool?
    
    init(_id: String? = nil, name: String? = nil, email: String? = nil, address: String? = nil, password: String? = nil, phone: String? = nil, role: String? = nil, isVerified: Bool? = nil) {
        self._id = _id
        self.name = name
        self.email = email
        self.address = address
        self.password = password
        self.phone = phone
        self.role = role
        self.isVerified = isVerified
    }
}

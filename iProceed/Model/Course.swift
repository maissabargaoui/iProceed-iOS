

import Foundation

struct Course : Encodable {
    
    var _id : String?
    var title : String?
    var description : String?
    var date : Date?
    
    init(_id: String? = nil, title: String? = nil, description: String? = nil, date: Date? = nil) {
        self._id = _id
        self.title = title
        self.description = description
        self.date = date
    }
    
}

//
//  FavoriteViewModel.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class FavoriteViewModel {
    
    func getFavorites(completed: @escaping (Bool, [Favorite]?) -> Void) {
        AF.request(Constants.serverUrl + "/favorite/my",
                   method: .post,
                   parameters: [
                    "user" : UserDefaults.standard.string(forKey: "userId")
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var favorites : [Favorite]? = []
                    for singleJsonItem in jsonData["favorites"] {
                        favorites!.append(self.makeFavorite(jsonItem: singleJsonItem.1))
                    }
                    completed(true, favorites)
                case let .failure(error):
                    print(error)
                    completed(false, nil)
                }
            }
    }
    
    func addFavorite(favorite: Favorite, completed: @escaping (Bool) -> Void) {
        AF.request(Constants.serverUrl + "/favorite",
                   method: .post,
                   parameters: [
                    "date" : DateUtils.formatFromDate(date: favorite.date),
                    "user" : favorite.user._id!,
                    "course" : favorite.course._id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func deleteFavorite(_id: String, completed: @escaping (Bool) -> Void) {
        print(_id)
        AF.request(Constants.serverUrl + "/favorite",
                   method: .delete,
                   parameters: ["_id" : _id],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func makeFavorite(jsonItem: JSON) -> Favorite {
        return Favorite(
            _id: jsonItem["_id"].stringValue,
            date: DateUtils.formatFromString(string: jsonItem["date"].stringValue),
            user: makeUser(jsonItem: jsonItem["user"]),
            course: makeCourse(jsonItem: jsonItem["course"])
        )
    }
    
    func makeUser(jsonItem: JSON) -> User {
        User(
            _id: jsonItem["_id"].stringValue,
            name: jsonItem["name"].stringValue,
            email: jsonItem["email"].stringValue,
            address: jsonItem["address"].stringValue,
            password: jsonItem["password"].stringValue,
            phone: jsonItem["phone"].stringValue,
            role: jsonItem["role"].stringValue,
            isVerified: jsonItem["isVerified"].boolValue
        )
    }
    
    func makeCourse(jsonItem: JSON) -> Course {
        Course(
            _id: jsonItem["_id"].stringValue,
            title: jsonItem["title"].stringValue,
            description: jsonItem["description"].stringValue,
            date: DateUtils.formatFromString(string: jsonItem["date"].stringValue)
        )
    }
    
}

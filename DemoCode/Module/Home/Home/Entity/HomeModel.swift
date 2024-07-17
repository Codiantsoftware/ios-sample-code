//
//  HomeModel.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation
import ObjectMapper

struct UserDetailsModel: Mappable {
    
    var profilePictureUrl: String?
    var profilePictureThumbUrl: String?
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var resetPasswordToken: String?
    var profilePicture: String?
    var status: String?
    var createdAt: String?
    var updatedAt: String?
    
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        
        profilePictureUrl <- map["profilePictureUrl"]
        profilePictureThumbUrl <- map["profilePictureThumbUrl"]
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        phoneNumber <- map["phoneNumber"]
        resetPasswordToken <- map["resetPasswordToken"]
        profilePicture <- map["profilePicture"]
        status <- map["status"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        
    }
}

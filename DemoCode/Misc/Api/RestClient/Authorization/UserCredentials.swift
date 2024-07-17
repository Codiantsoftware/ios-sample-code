//
//  UserCredentials.swift
//  Codiant iOS
//
//  Created by codiant iOS on 26/02/2024.
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class UserCredentials: Mappable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var token: String?
    var id: Int?
    var phone: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        token <- map["token"]
        id <- map["id"]
        phone <- map["phoneNumber"]

   }
    
    init() { }
    
    func update() {
        Authorization.shared.synchronize()
    }
}

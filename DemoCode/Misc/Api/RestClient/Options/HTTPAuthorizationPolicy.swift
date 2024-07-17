//
//  HTTPAuthorizationPolicy.swift
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Authorization policy to decide whether auth token must be appended in request header or not.
public enum HTTPAuthorizationPolicy {
    
    /// Request not require user authorization.
    case anonymous
    
    /// User must be authorized to make request.
    case signedIn
    
}

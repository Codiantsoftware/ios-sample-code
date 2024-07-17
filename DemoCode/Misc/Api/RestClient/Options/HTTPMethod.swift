//
//  HTTPMethod.swift
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// REST HTTP method types.
public enum HTTPMethod: String {
    
    /// HTTP `get` method.
    case get = "GET"
    
    /// HTTP `post` method.
    case post = "POST"
    
    /// HTTP `put` method.
    case put = "PUT"
    
    /// HTTP `patch` method.
    case patch = "PATCH"
    
    /// HTTP `delete` method.
    case delete = "DELETE"
    
}

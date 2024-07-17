//
//  HTTPParameterEncoding.swift
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Types to decide given parameters encoding.
public enum HTTPParameterEncoding {
    
    /// Multi-part.
    case formData
    
    /// Url parameter encoding.
    case url
    
    /// Json data in request body.
    case json
        
}

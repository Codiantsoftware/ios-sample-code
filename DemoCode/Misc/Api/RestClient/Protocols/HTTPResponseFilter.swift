//
//  HTTPResponseFilter.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// A filter which can be adopted to check response object.
public protocol HTTPResponseFilter {
    
    /// Filter to check response object.
    /// - Parameter response: Response object.
    func filter(response: inout HTTPResponse) throws
    
}

//
//  HTTPRequestFilter.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// A filter which can be adopted to append request headers.
public protocol HTTPRequestFilter {
    
    /// Filter to manipulate request configuration.
    /// - Parameter request: Request object that going to perform next.
    func filter(request: inout HTTPRequest) throws
    
}

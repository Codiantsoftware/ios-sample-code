//
//  HTTPRequestConfiguration.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Required configuration, request must be adopted the protocol.
public protocol HTTPRequestConfiguration {
    
    /// Server host url.
    var host: URL { get }
    
    /// Request endpoint.
    var uri: String { get set }
    
    /// REST HTTP method.
    var method: HTTPMethod { get set }
    
    /// Parameter encoding type.
    var encoding: HTTPParameterEncoding { get set }
    
    /// User authorization required or not.
    var authorizationPolicy: HTTPAuthorizationPolicy { get set }
    
    /// Builder to encode parameters.
    var parameterBuilder: HTTPParameterBuilder { get set }
    
}

///
extension HTTPRequestConfiguration {
    
    /// Common implementation to return host for each request.
    public var host: URL {
        ///
        guard let host = RestClient.shared.host else {
            fatalError("Server host url is missing.")
        }
//        let host = "https://node-api-demo.codiantdev.com/api/v1"
        
        return URL(string: host)!
    }
    
}

//
//  HTTPDefines.swift
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

///
public typealias HTTPParameters = [String: Any]

///
public typealias HTTPResult = (Result<HTTPResponse, Error>) -> Void

public typealias NotificationResponse = [AnyHashable: Any]

public typealias MatchResponse = HTTPParameters

///
internal extension NSError {
    
    static func error(code: Int, localizedDescription: String?) -> NSError {
        
       return NSError(domain: Bundle.main.bundleIdentifier!, code: code,
                         userInfo: [NSLocalizedDescriptionKey: (localizedDescription ?? "") == "The request timed out." ? "REQUEST_TIME_OUT"
                          : (localizedDescription ?? "")])
    }
    
}

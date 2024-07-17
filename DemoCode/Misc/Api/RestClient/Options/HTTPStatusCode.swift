//
//  HTTPStatusCode.swift
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// REST HTTP status codes.
public enum HTTPStatusCode: Int {
  
  /// The request has succeeded.
  case success = 200
  
  /// The request has succeeded and a new resource has been created as a result.
  case created = 201
  
  /// The mode of the app changes
  case accountDeleted = 204
  
  /// The URL of the requested resource has been changed permanently.
  case redirectionError = 301
  
  /// The server could not understand the request due to invalid syntax.
  case badRequest = 400
  
  /// The client must authenticate itself to get the requested response.
  case unauthorized = 401
  
  /// The client does not have access rights to the content.
  case forbidden = 403
  
  /// The server can not find requested resource.
  case notFound = 404
  
  case forceUpdate = 426

  /// The server has encountered a situation it doesn't know how to handle.
  case internalServerError = 500
  
  /// The request method is not supported by the server and cannot be handled.
  case methodNotImplemented = 501
  
  /// The server is not ready to handle the request.
  case gatewayTimeOut = 503
  
  /// The server have duplicate copy of resource.
  case duplicateExist = 409
}

/// URLSession system failure codes.
public enum SessionSystemCode: Int {
    
    /// Request timed-out.
    case requestTimeout  = -1001
    
    /// Internet appears to be offline.
    case internetOffline = -1009
    
    /// Unable to connect with given host.
    case unableToConnect = -1004
    
    /// Connection lost in middle of communication.
    case connectionLost  = -1005
    
}

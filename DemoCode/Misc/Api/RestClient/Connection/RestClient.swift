//
//  RestClient.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// REST client to handle request/response operations.
final public class RestClient {
  
  /// Server `HOST` url.
  public var host: String?
  
  /// Filter to manipulate request configurations.
  public var requestFilter: HTTPRequestFilter?
  
  /// Filter to manipulate/check response object.
  public var responseFilter: HTTPResponseFilter?
  
  /// Native url session object.
  private(set) var session: URLSession!
  
  /// Shared reference of REST client object.
  public static let shared: RestClient = {
    ///
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 600
    configuration.timeoutIntervalForResource = 600
    
    ///
    var instance = RestClient()
    instance.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    
    return instance
  }()
  
  public func cancelAllRequests() {
    
    session.getAllTasks { (tasks) in
      for task in tasks {
        task.cancel()
      }
    }
  }
  
  public func cancelRequestWith(path: String) {
    
    session.getAllTasks { (tasks) in
      for task in tasks {
        if let absoluteURL = task.originalRequest?.url?.absoluteString {
          if absoluteURL.contains(path) {
            task.cancel()
            break
          }
        }
      }
    }
  }
  
}

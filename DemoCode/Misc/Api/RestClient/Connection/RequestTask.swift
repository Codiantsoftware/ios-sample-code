//
//  RequestTask.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Performs request operations.
public struct RequestTask {
  
  /// Request object.
  public var request: HTTPRequest
  
  /// Closure to acknowledge request result.
  public var resultHandler: HTTPResult
  
  /// Initilize request task.
  /// - Parameters:
  ///   - request: Request object.
  ///   - resultHandler: Closure to acknowledge request result.
  public init(request: HTTPRequest,
              resultHandler: @escaping HTTPResult) {
    ///
    self.request = request
    self.resultHandler = resultHandler
  }
  
  /// Perfom request.
  public func perfom() {
    ///
    switch request.encoding {
      
    case .formData:
      self.uploadTask(request: request.urlRequest)
      
    default:
      self.dataTask(request: request.urlRequest)
    }
  }
  
  /// Perform web-service call of given request.
  /// - Parameter request: Request object.
  private func dataTask(request: URLRequest) {
    ///
    let dataTask = RestClient.shared.session.dataTask(with: request) { self.handleResponse(data: $0, response: $1, error: $2) }
    
    dataTask.resume()
  }
  
  /// Perform upload (multi-part) task of given request.
  /// - Parameter request: Request object.
  private func uploadTask(request: URLRequest) {
    var multipartRequest = request
    
    guard let data = multipartRequest.httpBody else { return }
    
    multipartRequest.httpBody = nil
    
    let uploadTask = RestClient.shared.session.uploadTask(with: multipartRequest, from: data) { self.handleResponse(data: $0, response: $1, error: $2) }
    
    uploadTask.resume()
  }
  
  /// Handle response.
  /// - Parameters:
  ///   - data: Raw data received in response.
  ///   - response: Native url response.
  ///   - error: Error in response.
  private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
    ///
    if let error = error {
      resultHandler(.failure(error))
      return
    }
    
    var httpResponse = HTTPResponse(urlResponse: response, data: data)
    
    ///
    /// Check for response filtering
    do {
      if let responseFilter = RestClient.shared.responseFilter {
        try responseFilter.filter(response: &httpResponse)
      }
      
      ///
      validateResponse(httpResponse)
      
    } catch {
      self.resultHandler(.failure(error))
    }
  }
  
  /// Performs validation on response.
  /// - Parameter response: Response object.
  private func validateResponse(_ response: HTTPResponse) {
    ///
    response.validate { (result) in
      ///
      switch result {
      case .success:
        self.resultHandler(.success(response))
        
      case .failure(let error):
        self.resultHandler(.failure(error))
      }
    }
  }
  
}

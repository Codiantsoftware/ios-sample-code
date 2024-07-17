//
//  HTTPResponse.swift
//

//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Localized response error.
public enum HTTPResponseError: LocalizedError {
  
  /// Response is not kind of `HTTPURLResponse`.
  case invalidResponse
  
  /// Localized error message.
  public var errorDescription: String? {
    
    switch self {
      
    case .invalidResponse:
      return "Failed to JSON encode parameters."
    }
  }
}

/// Class to hold and validate response object.
public struct HTTPResponse {
  
  /// Native url response object.
  public var urlResponse: URLResponse?
  
  /// Raw data received in response.
  public var data: Data?
  
  /// Return internal `data` object in response.
  public var serverResponse: Any? {
    //
    return self.getDataObject()
  }
  
  public var serverMessage: Any? {
    //
    return self.getMessageObject()
  }
  
  public var warehouseID: Any? {
     //
     return self.getWareHouseID()
   }
  
  public var isCouponApplied: Any? {
     //
     return self.getCouponCodeId()
   }
  
  public var statusCode: HTTPStatusCode {
    guard let response = urlResponse as? HTTPURLResponse,
      let statusCode = HTTPStatusCode(rawValue: response.statusCode) else {
        return HTTPStatusCode.badRequest
    }
    
    return statusCode
  }
  
  /// Initialize response object.
  /// - Parameters:
  ///   - urlResponse: Native url response object.
  ///   - data: Raw data received in response.
  public init(urlResponse: URLResponse?, data: Data?) {
    self.urlResponse = urlResponse
    self.data = data
  }
  
  /// Validates received response.
  /// - Parameter handler: Closure callback of the acknowledgement.
    internal func validate(_ handler: @escaping (Result<Void, Error>) -> Void) {
      ///
      guard let response = urlResponse as? HTTPURLResponse else {
        handler(.failure(HTTPResponseError.invalidResponse))
        return
      }
      
      /// Validates response content-type and HTTP status code.
      if let contentType = response.allHeaderFields["Content-Type"] as? String,
        
        contentType.contains("application/json"),
        
        let statusCode = HTTPStatusCode(rawValue: response.statusCode),
        
        (statusCode == .success || statusCode == .created),
        
        self.responseSuccess() {
        
        handler(.success(()))
        
        return
      }
      
  //    if let contentType = response.allHeaderFields["Content-Type"] as? String,
  //
  //      contentType.contains("application/json") {
  //      HudView.hide()
  //
  //      return
  //    }
      ///
      handler(.failure(NSError.error(code: response.statusCode, localizedDescription: self.error())))
      
    }
  
  /// Return the `data` object from response json.
  private func getDataObject() -> Any? {
    ///
    guard let json = serializeData() else { return nil }
    return json["data"]
  }
  
  /// Return the `data` object from response json.
  private func getMessageObject() -> Any? {
    ///
    guard let json = serializeData() else { return nil }
    return json["message"]
  }
  
  /// Return the `data` object from response json.
   private func getWareHouseID() -> Any? {
     ///
     guard let json = serializeData() else { return nil }
     return json["warehouse_id"]
   }
  
  /// Return the `data` object from response json.
   private func getCouponCodeId() -> Any? {
     ///
     guard let json = serializeData() else { return nil }
     return json["is_coupon_applied"]
   }
  
  /// Converts raw data to key/value object.
  private func serializeData() -> HTTPParameters? {
    ///
    guard let data = data else { return nil }
    
    return try? JSONSerialization.jsonObject(with: data) as? HTTPParameters
  }
  
  /// Return `success` value inside response json.
  private func responseSuccess() -> Bool {
    ///
//     if Constant.noSuccessInApi {
//          guard serializeData() != nil else { return false }
//          return true
//      } else {
//          guard let json = serializeData(),
//            let success = json["success"] as? Bool else { return false }
//          
//          return success
//
//      }
      guard let json = serializeData(),
        let success = json["success"] as? Bool else { return false }
      
      return success

  }
  
  /// Return `error` message inside response json.
  public func error() -> String? {
    ///
    guard let json = serializeData() else { return nil }
    
    ///
    if let errors = json["error"] as? [HTTPParameters],
      let error = errors.first {
      ///
      return error["message"] as? String
      
    } else if let error = json["error"] as? HTTPParameters,
      let message = error["message"] as? String {
      ///
      return message
      
    } else {
      return json["message"] as? String
    }
  }
  
}

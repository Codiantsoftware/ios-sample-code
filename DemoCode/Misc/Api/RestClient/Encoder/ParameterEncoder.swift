//
//  ParameterEncoder.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// Localized parameter encoding error.
public enum ParameterEncodingError: LocalizedError {
  // swiftlint:disable identifier_name
  /// JSON serialization failed.
  case JSONSerializationFailed
  
  /// URL is missing.
  case MissingURL
  
  /// Invalid encoding builder type.
  case InvalidType
  
  /// Localized error message.
  public var errorDescription: String? {
    ///
    switch self {
    case .JSONSerializationFailed:
      return "Failed to JSON encode parameters."
      
    case .MissingURL:
      return "URL encoding: Missing url."
      
    case .InvalidType:
      return "Passing invalid encoding type."
    }
  }
  
}

/// Parameter encoding builder types passed by request.
public enum ParameterEncoderBuilder {
  
  ///
  case formData(parameters: HTTPParameters, files: [HTTPMultipartFile], boundary: String)
  
  ///
  case urlEncoded(parameters: HTTPParameters)
  
  ///
  case json(parameters: HTTPParameters)
  
}

/// Class to encode request parameters as per given builder type.
internal class ParameterEncoder {
  
  ///
  static func encode(_ encoding: ParameterEncoderBuilder, request: inout URLRequest) throws {
    
    switch encoding {
      
    ///
    case .json(let parameters):
      guard let data = self.jsonEncode(parameters) else { throw ParameterEncodingError.JSONSerializationFailed }
      
      request.httpBody = data
      
    ///
    case .urlEncoded(let parameters):
      guard let url = request.url else { throw ParameterEncodingError.MissingURL }
      
      request.url = self.urlEncode(url, parameters: parameters)
      
    ///
    case .formData(let parameters, let files, let boundary):
      request.httpBody = self.formData(parameters: parameters, files: files, boundary: boundary)
    }
  }
  
}

// MARK: - JSON Encoding
extension ParameterEncoder {
  
  ///
  private static func jsonEncode(_ parameters: HTTPParameters) -> Data? {
    
    return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    
  }
  
}

// MARK: - URL Encoding
extension ParameterEncoder {
  
  ///
  private static func urlEncode(_ url: URL, parameters: HTTPParameters) -> URL {
    
    guard !parameters.isEmpty, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return url
    }
    
    urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0, value: "\($1)") })
    
    return urlComponents.url!
  }
  
}

// MARK: - Form Data
extension ParameterEncoder {
  
  ///
  private static func formData(parameters: HTTPParameters, files: [HTTPMultipartFile], boundary: String) -> Data {
    
    var formData = Data()
    
    ///
    if parameters.count > 0 {
      for (key, element) in parameters {
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        formData.append("\(element)\r\n".data(using: .utf8)!)
      }
    }
    
    ///
    for file in files {
      ///
      guard let data = file.data else { continue }
      
      let fileName = file.name + "." + file.ext
      let mimeType = file.mimeType!
      
      ///
      formData.append("--\(boundary)\r\n".data(using: .utf8)!)
      formData.append("Content-Disposition: form-data; name=\"\(file.parameterKey)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
      formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
      formData.append(data)
      formData.append("\r\n".data(using: .utf8)!)
    }
    
    formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    return formData
  }
  
}

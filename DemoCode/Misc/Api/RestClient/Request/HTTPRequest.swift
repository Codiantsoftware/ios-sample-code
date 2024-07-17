//
//  HTTPRequest.swift
//
//  //
//
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Construct request object.
public struct HTTPRequest: HTTPRequestConfiguration {
    
    /// Request endpoint.
    public var uri: String
    
    /// HTTP method.
    public var method: HTTPMethod
    
    /// Type of parameter encoding.
    public var encoding: HTTPParameterEncoding
    
    /// User authorization policy for the request.
    public var authorizationPolicy: HTTPAuthorizationPolicy
    
    /// Parameter encoding builder type.
    public var parameterBuilder: HTTPParameterBuilder
    
    private (set) var urlRequest: URLRequest!
    
    private let boundary = UUID().uuidString
    
    /// Initialize and build request object.
    /// - Parameters:
    ///   - uri: Request endpoint.
    ///   - method: HTTP method.
    ///   - authorizationPolicy: User authorization policy type.
    ///   - parameterBuilder: Request parameters.
    ///   - encoding: HTTP method.
    public init(uri: String,
                method: HTTPMethod,
                authorizationPolicy: HTTPAuthorizationPolicy,
                parameterBuilder: HTTPParameterBuilder,
                encoding: HTTPParameterEncoding) throws {
        
        //
        self.uri = uri
        self.method = method
        self.authorizationPolicy = authorizationPolicy
        self.parameterBuilder = parameterBuilder
        self.encoding = encoding
        
        do {
            try self.buildRequest()
            
            // Check for request filtering
            if let requestFilter = RestClient.shared.requestFilter {
                try requestFilter.filter(request: &self)
            }
        } catch {
            throw error
        }
    }
    
    /// Set value in request header.
    /// - Parameters:
    ///   - value: Value to set.
    ///   - field: Key for value.
    public mutating func setValue(_ value: String, forHTTPHeaderField field: String) {
        guard self.urlRequest != nil else { return }
        
        self.urlRequest!.setValue(value, forHTTPHeaderField: field)
    }
    
    // MARK: - Private
    /// Build request object.
    private mutating func buildRequest() throws {
        
        let url = host.appendingPathComponent(uri)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            try self.encode(&request)
            
            self.appendHeaders(&request)
            self.urlRequest = request
            
        } catch {
            throw error
        }
    }
    
}

// MARK: - Parameter Encoding
extension HTTPRequest {
    
    /// Parameters encoding and append in given request.
    /// - Parameter request: Request object reference.
    private func encode(_ request: inout URLRequest) throws {
        
        do {
            
            switch parameterBuilder {
                
            case .request(let parameters):
                
                switch encoding {
                case .json:
                    try ParameterEncoder.encode(.json(parameters: parameters), request: &request)
                    
                case .url:
                    try ParameterEncoder.encode(.urlEncoded(parameters: parameters), request: &request)
                    
                default:
                    throw ParameterEncodingError.InvalidType
                }
                
            case .requestFormData(let parameters, let files):
                
                switch encoding {
                case .formData:
                    try ParameterEncoder.encode(.formData(parameters: parameters, files: files, boundary: boundary), request: &request)
                    
                default:
                    throw ParameterEncodingError.InvalidType
                }
            }
        } catch {
            throw error
        }
    }
    
}

// MARK: - HTTP Headers and Authorization
extension HTTPRequest {
    
    /// Append common fields/values to request header.
    /// - Parameter request: Request object reference.
    private func appendHeaders(_ request: inout URLRequest) {
        
        let contentType = encoding == .formData ?"multipart/form-data; boundary=\(boundary)" : "application/json; charset=utf-8"
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")

        

    }
    
}

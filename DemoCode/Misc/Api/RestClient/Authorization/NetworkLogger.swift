//
//  NetworkLogger.swift
//  NetworkLayer
//
//

import Foundation

class NetworkLogger {
  static func log(httpRequest: HTTPRequest) {
    
    let request = httpRequest.urlRequest
    
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    
    defer {
      print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
    }
    
    let urlAsString = request?.url?.absoluteString ?? ""
    let urlComponents = NSURLComponents(string: urlAsString)
    
    let method = request?.httpMethod != nil ? "\(request?.httpMethod ?? "")" : ""
    let path = "\(urlComponents?.path ?? "")"
    let query = "\(urlComponents?.query ?? "")"
    let host = "\(urlComponents?.host ?? "")"
    
    var logOutput = """
    \(urlAsString) \n
    \(method) \(path)?\(query) HTTP/1.1 \n
    HOST: \(host)\n
    """
    for (key, value) in request?.allHTTPHeaderFields ?? [:] {
      logOutput += "\(key): \(value) \n"
    }
    
    if let body = request?.httpBody {
      logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
    }
    
    print(logOutput)
  }
  
  static func log(httpResponse: HTTPResponse) {
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    
    defer {
      print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
    }
    
    if let response = httpResponse.urlResponse {
      print("Validating request: \(response.url?.absoluteString ?? "") with HTTP status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
    }
    print("Response: \(httpResponse.data?.prettyPrintedJSONString ?? "")")
  }
  
  static func log(urlResponse: URLResponse?, data: Data?) {
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    
    defer {
      print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
    }
    
    if let response = urlResponse {
      print("Validating request: \(response.url?.absoluteString ?? "") with HTTP status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
    }
    print("Response: \(data?.prettyPrintedJSONString ?? "")")
  }
  
  static func log(JSONResponse: [String: Any]) {
    
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    
    defer {
      print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
    }
    
    var logOutput = """
        """
    for (key, value) in JSONResponse {
      logOutput += "\(key): \(value) \n"
    }
    print(logOutput)
  }
  
}

extension Data {
  var prettyPrintedJSONString: String {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "" }
    
    return prettyPrintedString as String
  }
}

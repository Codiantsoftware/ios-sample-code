//
//  RequestUploadTask.swift
// Codiant
//
//  Created by codiant on 17/04/22.
//

import Foundation

/// Performs upload data task operations.
public class RequestUploadTask: NSObject {
	
	/// Request object.
	public var request: HTTPRequest
	
	/// Closure to acknowledge request result.
	public var resultHandler: HTTPResult
	
	/// Closure to notify upload progress.
	public var progressHandler: ((Float) -> Void)?
	
	/// URL Session.
	private var urlSession: URLSession!
	
	
	/// Initilize task.
	/// - Parameters:
	///   - request: Request object.
	///   - resultHandler: Closure to acknowledge request result.
	public init(request: HTTPRequest,
							progress: @escaping (Float) -> Void,
							resultHandler: @escaping HTTPResult) {
		guard request.encoding == .formData else {
			fatalError("Request upload task: invalid encoding")
		}
		
		self.request = request
		self.progressHandler = progress
		self.resultHandler = resultHandler
		
		super.init()
		
		self.initializeSession()
	}
	
	/// Perfom request.
	public func perfom() {
		self.uploadTask(request: request.urlRequest)
	}
	
	/// Initialize session
	private func initializeSession() {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 120
		configuration.timeoutIntervalForResource = 120
		
		urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
	}
	
	/// Perform upload (multi-part) task of given request.
	/// - Parameter request: Request object.
	private func uploadTask(request: URLRequest) {
		var multipartRequest = request
		
		guard let data = multipartRequest.httpBody else { return }
		
		multipartRequest.httpBody = nil
		
		let uploadTask = urlSession.uploadTask(with: multipartRequest, from: data) { self.handleResponse(data: $0, response: $1, error: $2) }
		
		uploadTask.resume()
	}
	
	/// Handle response.
	/// - Parameters:
	///   - data: Raw data received in response.
	///   - response: Native url response.
	///   - error: Error in response.
	private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
		if let error = error {
			resultHandler(.failure(error))
			return
		}
		
		var httpResponse = HTTPResponse(urlResponse: response, data: data)
		
		/// Check for response filtering
		do {
			if let responseFilter = RestClient.shared.responseFilter {
				try responseFilter.filter(response: &httpResponse)
			}
			
			validateResponse(httpResponse)
		} catch {
			self.resultHandler(.failure(error))
		}
	}
	
	/// Performs validation on response.
	/// - Parameter response: Response object.
	private func validateResponse(_ response: HTTPResponse) {
		response.validate { (result) in
			switch result {
			case .success():
				self.resultHandler(.success(response))
			case .failure(let error):
				self.resultHandler(.failure(error))
			}
		}
	}
}

extension RequestUploadTask: URLSessionTaskDelegate {
	public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
		progressHandler?(uploadProgress)
	}
}

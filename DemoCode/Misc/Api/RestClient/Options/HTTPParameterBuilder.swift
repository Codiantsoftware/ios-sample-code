//
//  HTTPParameterBuilder.swift

//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

/// Builder to encode given parameters and add to the request.
public enum HTTPParameterBuilder {
    
    /// Parameters only request.
    case request(parameters: HTTPParameters)
    
    /// Multi-part request.
    case requestFormData(parameters: HTTPParameters, files: [HTTPMultipartFile])
    
}

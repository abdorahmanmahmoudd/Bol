//
//  API+Error.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import Foundation

extension API {
    
    enum Error: LocalizedError {

        case decodingError(Swift.Error)
        case networkError(Swift.Error)
        case httpErrorCode(Int)
        case invalidURL
        case invalidRequest
        case nonHTTPResponse
        case unknown
        
        
        // Custom error codes so that we recognize it quicker
        var code: Int {
            switch self {
            case .decodingError:
                return -11001
            case .networkError:
                return -11002
            case .invalidURL:
                return -11004
            case .invalidRequest:
                return -11005
            case .httpErrorCode(let code):
                return code
            case .nonHTTPResponse:
                return -11006
            case .unknown:
                return -11007
            }
        }
        
        var errorDescription: String? {
            
            let genericMessage = "\("GENERAL_ERROR_DESCRIPTION".localized)\(code)"
            
            switch self {
            
            case .decodingError, .httpErrorCode, .nonHTTPResponse, .unknown, .invalidRequest:
            return genericMessage
            
            case let .networkError(error):
                if (error as NSError).domain == NSURLErrorDomain, (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    return (error as NSError).localizedDescription
                }
                return genericMessage
                
            case .invalidURL:
                return "INVALID_URL".localized
            }
        }
    }
}


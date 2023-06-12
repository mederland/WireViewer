//
//  APIError.swift
//  WireViewerKit
//
//  Created by Meder iZimov on 6/11/23.
//

import Foundation

enum APIError: Error {
    case incorrectURL
    case responseError
    case parsingJSONError
    
    var localizedDescription: String {
        switch self {
        case .incorrectURL:
            return "The URL is Incorrect."
        case .responseError:
            return "An Error Occured while fetching data."
        case .parsingJSONError:
            return "An Error Occured while trying to Parse JSON."
        }
    }
}

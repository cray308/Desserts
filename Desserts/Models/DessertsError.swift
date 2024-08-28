//
//  DessertsError.swift
//  Desserts
//
//  Created by Chris Ray on 8/26/24.
//

import Foundation

enum DessertsError: Error, LocalizedError {
    case unexpected(Error)
    case failedRequest
    case missingDetails

    var errorDescription: String? {
        switch self {
        case .unexpected(let error):
            return "Unexpected error: \(error.localizedDescription)"
        case .failedRequest:
            return "Failed to load the requested information. Please retry."
        case .missingDetails:
            return "The requested meal details are not available."
        }
    }
}

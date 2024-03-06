//
//  CoreDataError.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Foundation

enum CoreDataError: LocalizedError {
    case addingError
    case deletingError
    case objectNotFound
    case nilProperty
    case genericError(Error)
    
    var errorDescription: String? {
        return switch self {
        case .genericError(let error): error.localizedDescription
        default: String(describing: self).capitalized
        }
    }
}

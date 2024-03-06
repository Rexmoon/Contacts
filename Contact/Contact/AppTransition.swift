//
//  AppTransition.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

enum AppTransition {
    case showHome
    
    var identifier: String { String(describing: self) }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        return switch self {
        case .showHome: ContactsCoordinator(router: router)
        }
    }
}

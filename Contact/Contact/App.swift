//
//  App.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import UIKit

final class App: Coordinator {
    
    var navigationController: UINavigationController = .init()
    
    func start() {
        process(route: .showHome)
    }
}

extension App: AppRouter {
    
    func process(route: AppTransition) {
        let coordinator = route.coordinatorFor(router: self)
        coordinator.start()
        
        #if DEBUG
        print(route.identifier)
        #endif
    }
    
    func exit() {
        navigationController.popToRootViewController(animated: true)
    }
}

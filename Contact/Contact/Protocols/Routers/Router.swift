//
//  Router.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import UIKit

protocol Router {
    associatedtype Route
    var navigationController: UINavigationController { get set }
    func process(route: Route)
    func exit()
}

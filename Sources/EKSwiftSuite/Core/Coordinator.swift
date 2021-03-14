//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

public protocol Coordinator: class {
    var delegate: CoordinatorDelegate? { get set }
    func append(child: Coordinator)
    func remove(child: Coordinator)
}

public protocol CoordinatorDelegate: class {
    func childCoordinatorDidFinish(_ childCoordinator: Coordinator)
}

public extension CoordinatorDelegate where Self: Coordinator {
     func childCoordinatorDidFinish(_ coordinator: Coordinator) {
        remove(child: coordinator)
        coordinator.delegate = nil
    }
}

// MARK: - BaseCoordinator

open class BaseCoordinator<V: UIViewController>: Coordinator, CoordinatorDelegate {

    open unowned var rootViewController: V
    private var childCoordinators: [Coordinator] = []
    open weak var delegate: CoordinatorDelegate?

    public init(rootViewController: V) {
        self.rootViewController = rootViewController
    }

    open func append(child: Coordinator) {
        child.delegate = self
        childCoordinators.append(child)
    }

    open func remove(child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            coordinator === child
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    open func start() {
        
    }
}

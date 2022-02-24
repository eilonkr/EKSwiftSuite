
#if !os(macOS)
import UIKit

public protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    func append(child: Coordinator)
    func remove(child: Coordinator)
}

public protocol CoordinatorDelegate: AnyObject {
    func childCoordinatorDidFinish(_ childCoordinator: Coordinator)
}

public extension CoordinatorDelegate where Self: Coordinator {
     func childCoordinatorDidFinish(_ coordinator: Coordinator) {
        remove(child: coordinator)
        coordinator.delegate = nil
    }
}

// MARK: - BaseCoordinator

open class BaseCoordinator<V: UIViewController>: NSObject, Coordinator, CoordinatorDelegate {

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
#endif

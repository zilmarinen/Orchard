//
//  ActorUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 28/03/2021.
//

import Cocoa
import Meadow

class ActorUtilityCoordinator: ActorCoordinator {
    
    lazy var inspectorCoordinator: ActorInspectorCoordinator = {
       
        let coordinator = ActorInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var placementCoordinator: ActorPlacementCoordinator = {
       
        let coordinator = ActorPlacementCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: ActorViewModel = {
       
        return ActorViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let option = option as? ActorUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? ActorCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let stateObserver = stateObserver {
            
            viewModel.unsubscribe(stateObserver)
        }
        
        super.stop(then: completion)
    }
}

extension ActorUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .placement:
            
            start(child: placementCoordinator, with: nil)
            
        default: break
        }
    }
}


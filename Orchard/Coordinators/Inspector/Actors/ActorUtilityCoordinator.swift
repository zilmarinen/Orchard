//
//  ActorUtilityCoordinator.swift
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
    
    override init(controller: ActorInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
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


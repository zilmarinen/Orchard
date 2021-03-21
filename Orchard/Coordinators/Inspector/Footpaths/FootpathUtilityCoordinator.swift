//
//  FootpathUtilityCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class FootpathUtilityCoordinator: FootpathCoordinator {
    
    lazy var inspectorCoordinator: FootpathInspectorCoordinator = {
       
        let coordinator = FootpathInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var materialCoordinator: FootpathMaterialCoordinator = {
       
        let coordinator = FootpathMaterialCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: FootpathViewModel = {
       
        return FootpathViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? FootpathUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? FootpathCoordinator else { return }
        
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

extension FootpathUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .material:
            
            start(child: materialCoordinator, with: nil)
            
        default: break
        }
    }
}



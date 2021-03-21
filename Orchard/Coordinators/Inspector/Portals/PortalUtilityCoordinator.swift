//
//  PortalUtilityCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class PortalUtilityCoordinator: PortalCoordinator {
    
    lazy var inspectorCoordinator: PortalInspectorCoordinator = {
       
        let coordinator = PortalInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildCoordinator: PortalBuildCoordinator = {
       
        let coordinator = PortalBuildCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: PortalViewModel = {
       
        return PortalViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let option = option as? PortalUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? PortalCoordinator else { return }
        
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

extension PortalUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .build:
            
            start(child: buildCoordinator, with: nil)
            
        default: break
        }
    }
}


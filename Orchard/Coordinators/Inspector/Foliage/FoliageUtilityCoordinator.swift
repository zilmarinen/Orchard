//
//  FoliageUtilityCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class FoliageUtilityCoordinator: FoliageCoordinator {
    
    lazy var inspectorCoordinator: FoliageInspectorCoordinator = {
       
        let coordinator = FoliageInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var plantCoordinator: FoliagePlantCoordinator = {
       
        let coordinator = FoliagePlantCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: FoliageViewModel = {
       
        return FoliageViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let option = option as? FoliageUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? FoliageCoordinator else { return }
        
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

extension FoliageUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .plant:
            
            start(child: plantCoordinator, with: nil)
            
        default: break
        }
    }
}

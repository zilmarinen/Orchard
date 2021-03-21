//
//  WaterUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterUtilityCoordinator: WaterCoordinator {
    
    lazy var inspectorCoordinator: WaterInspectorCoordinator = {
       
        let coordinator = WaterInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var materialCoordinator: WaterMaterialCoordinator = {
       
        let coordinator = WaterMaterialCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var elevationCoordinator: WaterElevationCoordinator = {
       
        let coordinator = WaterElevationCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: WaterViewModel = {
       
        return WaterViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let option = option as? WaterUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? WaterCoordinator else { return }
        
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

extension WaterUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .material:
            
            start(child: materialCoordinator, with: nil)
            
        case .elevation:
            
            start(child: elevationCoordinator, with: nil)
            
        default: break
        }
    }
}

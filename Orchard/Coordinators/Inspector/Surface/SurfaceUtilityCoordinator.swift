//
//  SurfaceUtilityCoordinator.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Cocoa
import Meadow

class SurfaceUtilityCoordinator: SurfaceCoordinator {
    
    lazy var inspectorCoordinator: SurfaceInspectorCoordinator = {
       
        let coordinator = SurfaceInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var materialCoordinator: SurfaceMaterialCoordinator = {
       
        let coordinator = SurfaceMaterialCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var elevationCoordinator: SurfaceElevationCoordinator = {
       
        let coordinator = SurfaceElevationCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: SurfaceViewModel = {
       
        return SurfaceViewModel(initialState: .empty)
    }()
    
    var stateObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let option = option as? SurfaceUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? SurfaceCoordinator else { return }
        
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

extension SurfaceUtilityCoordinator {
    
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

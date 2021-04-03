//
//  WaterUtilityCoordinator.swift
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
    
    lazy var viewModel: WaterViewModel = {
       
        return WaterViewModel(initialState: .empty)
    }()
    
    override init(controller: WaterInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
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
}

extension WaterUtilityCoordinator {
    
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

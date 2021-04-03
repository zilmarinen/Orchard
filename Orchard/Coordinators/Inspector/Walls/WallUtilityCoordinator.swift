//
//  WallUtilityCoordinator.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Cocoa
import Meadow

class WallUtilityCoordinator: WallCoordinator {
    
    lazy var inspectorCoordinator: WallInspectorCoordinator = {
       
        let coordinator = WallInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildCoordinator: WallBuildCoordinator = {
       
        let coordinator = WallBuildCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: WallViewModel = {
       
        return WallViewModel(initialState: .empty)
    }()
    
    override init(controller: WallInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? WallUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? WallCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
}

extension WallUtilityCoordinator {
    
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

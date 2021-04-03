//
//  FenceUtilityCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class FenceUtilityCoordinator: FenceCoordinator {
    
    lazy var inspectorCoordinator: FenceInspectorCoordinator = {
       
        let coordinator = FenceInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildCoordinator: FenceBuildCoordinator = {
       
        let coordinator = FenceBuildCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: FenceViewModel = {
       
        return FenceViewModel(initialState: .empty)
    }()
    
    override init(controller: FenceInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? FenceUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? FenceCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
}

extension FenceUtilityCoordinator {
    
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

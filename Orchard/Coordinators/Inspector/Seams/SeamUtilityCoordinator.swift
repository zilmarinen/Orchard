//
//  SeamUtilityCoordinator.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Cocoa
import Meadow

class SeamUtilityCoordinator: SeamCoordinator {
    
    lazy var inspectorCoordinator: SeamInspectorCoordinator = {
       
        let coordinator = SeamInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var stitchCoordinator: SeamStitchCoordinator = {
       
        let coordinator = SeamStitchCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: SeamViewModel = {
       
        return SeamViewModel(initialState: .empty)
    }()
    
    override init(controller: SeamInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? SeamUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? SeamCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
}

extension SeamUtilityCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        switch currentState {
        
        case .inspector:
            
            start(child: inspectorCoordinator, with: currentState)
            
        case .stitch:
            
            start(child: stitchCoordinator, with: nil)
            
        default: break
        }
    }
}


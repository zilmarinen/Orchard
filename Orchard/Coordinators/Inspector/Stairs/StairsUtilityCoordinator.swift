//
//  StairsUtilityCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class StairsUtilityCoordinator: StairsCoordinator {
    
    lazy var inspectorCoordinator: StairsInspectorCoordinator = {
       
        let coordinator = StairsInspectorCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildCoordinator: StairsBuildCoordinator = {
       
        let coordinator = StairsBuildCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var viewModel: StairsViewModel = {
       
        return StairsViewModel(initialState: .empty)
    }()
    
    override init(controller: StairsInspectorViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let option = option as? StairsUtilityCoordinator.ViewState else { return }
        
        viewModel.state = option
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? StairsCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
}

extension StairsUtilityCoordinator {
    
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

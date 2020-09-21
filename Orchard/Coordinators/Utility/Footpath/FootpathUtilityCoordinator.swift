//
//  FootpathUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

class FootpathUtilityCoordinator: Coordinator<FootpathUtilityViewController> {
    
    lazy var viewModel: ViewModel = {
           
        return ViewModel(initialState: .empty)
    }()
    
    lazy var footpathBuildUtilityCoordinator: FootpathBuildUtilityCoordinator = {
       
        let coordinator = FootpathBuildUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathPaintUtilityCoordinator: FootpathPaintUtilityCoordinator = {
       
        let coordinator = FootpathPaintUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: FootpathUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        viewModel.start(with: option)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        stopChildren()
        
        viewModel.stop()
        
        completion?()
    }
}

extension FootpathUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
           
            self.stopChildren()
        
            switch currentState {
                
            case .build:
                
                self.start(child: self.footpathBuildUtilityCoordinator, with: currentState)
                
            case .paint:
                
                self.start(child: self.footpathPaintUtilityCoordinator, with: currentState)
                
            default: break
            }
        }
    }
}


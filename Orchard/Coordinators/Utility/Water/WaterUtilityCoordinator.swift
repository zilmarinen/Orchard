//
//  WaterUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 15/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

class WaterUtilityCoordinator: Coordinator<WaterUtilityViewController> {
    
    lazy var viewModel: ViewModel = {
           
        return ViewModel(initialState: .empty)
    }()
    
    lazy var waterBuildUtilityCoordinator: WaterBuildUtilityCoordinator = {
       
        let coordinator = WaterBuildUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var waterPaintUtilityCoordinator: WaterPaintUtilityCoordinator = {
       
        let coordinator = WaterPaintUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: WaterUtilityViewController) {
        
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

extension WaterUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
           
            self.stopChildren()
        
            switch currentState {
                
            case .build:
                
                self.start(child: self.waterBuildUtilityCoordinator, with: currentState)
                
            case .paint:
                
                self.start(child: self.waterPaintUtilityCoordinator, with: currentState)
                
            default: break
            }
        }
    }
}

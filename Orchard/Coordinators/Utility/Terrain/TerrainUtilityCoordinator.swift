//
//  TerrainUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

class TerrainUtilityCoordinator: Coordinator<TerrainUtilityViewController> {
    
    lazy var viewModel: ViewModel = {
       
        return ViewModel(initialState: .empty)
    }()
    
    lazy var terrainBuildUtilityCoordinator: TerrainBuildUtilityCoordinator = {
       
        let coordinator = TerrainBuildUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainPaintUtilityCoordinator: TerrainPaintUtilityCoordinator = {
       
        let coordinator = TerrainPaintUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainTerraformUtilityCoordinator: TerrainTerraformUtilityCoordinator = {
       
        let coordinator = TerrainTerraformUtilityCoordinator(controller: controller)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: TerrainUtilityViewController) {
        
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

extension TerrainUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
           
            self.stopChildren()
        
            switch currentState {
                
            case .build:
                
                self.start(child: self.terrainBuildUtilityCoordinator, with: currentState)
                
            case .paint:
                
                self.start(child: self.terrainPaintUtilityCoordinator, with: currentState)
                
            case .terraform:
                
                self.start(child: self.terrainTerraformUtilityCoordinator, with: currentState)
                
            default: break
            }
        }
    }
}

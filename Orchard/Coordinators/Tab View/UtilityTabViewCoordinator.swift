//
//  UtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class UtilityTabViewCoordinator: Coordinator<UtilityTabViewController> {
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    lazy var areaUtilityCoordinator: AreaUtilityCoordinator = {
        
        guard let viewController = self.controller.children[ViewState.Tab.area.rawValue] as? AreaUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathUtilityCoordinator: FootpathUtilityCoordinator = {
        
        guard let viewController = self.controller.children[ViewState.Tab.footpath.rawValue] as? FootpathUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainUtilityCoordinator: TerrainUtilityCoordinator = {
        
        guard let viewController = self.controller.children[ViewState.Tab.terrain.rawValue] as? TerrainUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var waterUtilityCoordinator: WaterUtilityCoordinator = {
        
        guard let viewController = self.controller.children[ViewState.Tab.water.rawValue] as? WaterUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = WaterUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: UtilityTabViewController) {
        
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

extension UtilityTabViewCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        DispatchQueue.main.async {
            
            self.stopChildren()
         
            switch currentState {
                
            case .area(let node):
                
                self.start(child: self.areaUtilityCoordinator, with: node)
                
            case .footpath(let node):
                
                self.start(child: self.footpathUtilityCoordinator, with: node)
                
            case .terrain(let node):
                
                self.start(child: self.terrainUtilityCoordinator, with: node)
                
            case .water(let node):
                
                self.start(child: self.waterUtilityCoordinator, with: node)
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = currentState.tab.rawValue
        }
    }
}

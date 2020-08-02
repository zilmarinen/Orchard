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
    
    lazy var terrainUtilityCoordinator: TerrainUtilityCoordinator = {
        
        guard let viewController = self.controller.children[ViewState.Tab.terrain.rawValue] as? TerrainUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: UtilityTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        print("start: UtilityTabViewCoordinator")
        viewModel.subscribe(stateDidChange(from:to:))
        
        guard let node = option as? SceneGraphIdentifiable else { return }
        
        viewModel.select(node: node)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        print("stop: UtilityTabViewCoordinator")
        viewModel.clear()
        
        completion?()
    }
}

extension UtilityTabViewCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        DispatchQueue.main.async {
            
            self.stopChildren()
         
            switch currentState {
                
            case .terrain(let node):
                
                self.start(child: self.terrainUtilityCoordinator, with: node)
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = currentState.tab.rawValue
        }
    }
}

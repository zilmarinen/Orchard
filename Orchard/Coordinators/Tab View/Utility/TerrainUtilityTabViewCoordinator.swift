//
//  TerrainUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class TerrainUtilityTabViewCoordinator: Coordinator<TerrainUtilityTabViewController> {
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()

    override init(controller: TerrainUtilityTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilityTabViewCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        DispatchQueue.main.async {
         
            let viewController = self.controller.children[currentState.tab.rawValue]
            
            switch currentState {
                
            case .build(let node):
                
                guard let viewController = viewController as? TerrainUtilityBuildViewController else { fatalError("Invalid view controller hierarchy") }
                
                //
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = currentState.tab.rawValue
        }
    }
}

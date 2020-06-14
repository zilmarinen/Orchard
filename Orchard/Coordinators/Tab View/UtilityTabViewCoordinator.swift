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

    override init(controller: UtilityTabViewController) {
        
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

extension UtilityTabViewCoordinator {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
         
            let viewController = self.controller.children[to.tab.rawValue]
            
            switch to {
                
            case .terrain(let node):
                
                guard let viewController = viewController as? TerrainUtilityViewController else { fatalError("Invalid view controller hierarchy") }
                
                viewController.inspector = TerrainInspector(node: node)
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = to.tab.rawValue
        }
    }
}

extension UtilityTabViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        self.viewModel.select(node: node)
    }
}

//
//  InspectorTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class InspectorTabViewController: NSTabViewController {
    
    weak var coordinator: InspectorTabViewCoordinator?
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension InspectorTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            let viewController = self.children[to.tab.rawValue]
            
            switch to {
                
            case .meadow(let node):
                
                guard let viewController = viewController as? MeadowInspectorViewController else { fatalError("Invalid view controller hierarchy") }
                
                viewController.inspector = MeadowInspector(node: node)
                
            case .terrain(let node):
                
                guard let viewController = viewController as? TerrainInspectorViewController else { fatalError("Invalid view controller hierarchy") }
                
                viewController.inspector = TerrainInspector(node: node)
                
            default: break
            }
            
            self.selectedTabViewItemIndex = to.tab.rawValue
        }
    }
}

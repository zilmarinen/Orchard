//
//  InspectorTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class InspectorTabViewController: NSTabViewController {
    
    lazy var viewModel = {
        
        return InspectorViewModel(initialState: .empty)
    }()
}

extension InspectorTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension InspectorTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
        
        case .area:
            
            guard let viewController = childViewControllers[to.sortOrder] as? AreaInspectorViewController else { break }
            
            //
            
        case .camera:
            
            guard let viewController = childViewControllers[to.sortOrder] as? CameraInspectorViewController else { break }
            
            //
            
        case .foliage:
            
            guard let viewController = childViewControllers[to.sortOrder] as? FoliageInspectorViewController else { break }
            
            //
            
        case .footpath:
            
            guard let viewController = childViewControllers[to.sortOrder] as? FootpathInspectorViewController else { break }
            
            //
            
        case.scene(let meadow):
            
            guard let viewController = childViewControllers[to.sortOrder] as? SceneInspectorViewController else { break }
            
            viewController.nameTextField.stringValue = meadow.rootNode.name ?? ""
            
        case.terrain:
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainInspectorViewController else { break }
            
            //
            
        case .water:
            
            guard let viewController = childViewControllers[to.sortOrder] as? WaterInspectorViewController else { break }
            
            //
            
        default: break
        }
    }
}

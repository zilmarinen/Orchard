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
        
        return InspectorTabViewModel(initialState: .empty)
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
        
        case .area(let area):
            
            guard let viewController = childViewControllers[to.sortOrder] as? AreaInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(area)
            
        case .camera(let cameraJib):
            
            guard let viewController = childViewControllers[to.sortOrder] as? CameraInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(cameraJib)
            
        case .foliage(let foliage):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FoliageInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(foliage)
            
        case .footpath(let footpath):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FootpathInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(footpath)
            
        case.scene(let meadow):
            
            guard let viewController = childViewControllers[to.sortOrder] as? SceneInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(meadow)
            
        case.terrain(let terrain, _, _, let layer):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(terrain, layer)
            
        case .water(let water):
            
            guard let viewController = childViewControllers[to.sortOrder] as? WaterInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(water)
            
        default: break
        }
    }
}

//
//  TerrainUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class TerrainUtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return TerrainUtilitiesTabViewModel(initialState: .empty)
    }()
}

extension TerrainUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        case .build(let terrain):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainBuildUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .inspecting(terrain, TerrainType.bedrock)
                
            case .inspecting(let terrain, let terrainType):
                
                viewController.viewModel.state = .inspecting(terrain, terrainType)
            }
            
        case .terraform(let terrain):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainTerraformUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .inspecting(terrain, .tile, false)
                
            case .inspecting(let terrain, let toolType, let smooth):
                
                viewController.viewModel.state = .inspecting(terrain, toolType, smooth)
            }
        
        case .paint(let terrain):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainPaintUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .inspecting(terrain, TerrainType.bedrock, .tile)
                
            case .inspecting(let terrain, let terrainType, let toolType):
                
                viewController.viewModel.state = .inspecting(terrain, terrainType, toolType)
            }
            
        default: break
        }
    }
}

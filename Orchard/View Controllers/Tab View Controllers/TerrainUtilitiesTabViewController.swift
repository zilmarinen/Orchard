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
        
        return TerrainUtilitiesTabViewModel(initialState: .empty(meadow: nil))
    }()
}

extension TerrainUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        if let from = from {
            
            let viewController = children[from.sortOrder]
            
            switch from {
                
            case .build(let meadow):
                
                guard let viewController = viewController as? TerrainBuildUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .terraform(let meadow):
                
                guard let viewController = viewController as? TerrainTerraformUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .paint(let meadow):
                
                guard let viewController = viewController as? TerrainPaintUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
            
        case .build(let meadow):
            
            guard let viewController = viewController as? TerrainBuildUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .build(meadow: meadow, terrainType: TerrainType.bedrock)
                
            default: break
            }
            
        case .terraform(let meadow):
            
            guard let viewController = viewController as? TerrainTerraformUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .terraform(meadow: meadow, toolType: .tile, smooth: false)
                
            default: break
            }
        
        case .paint(let meadow):
            
            guard let viewController = viewController as? TerrainPaintUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .paint(meadow: meadow, terrainType: TerrainType.bedrock, toolType: .tile)
                
            default: break
            }
            
        default: break
        }
    }
}

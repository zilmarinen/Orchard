//
//  UtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class UtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return UtilitiesTabViewModel(initialState: .empty(meadow: nil))
    }()
}

extension UtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension UtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        if let from = from {
            
            let viewController = children[from.sortOrder]
            
            switch from {
                
            case .area(let meadow):
                
                guard let viewController = viewController as? AreaUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .foliage(let meadow):
                
                guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .footpath(let meadow):
                
                guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .terrain(let meadow):
                
                guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            case .water(let meadow):
                
                guard let viewController = viewController as? WaterUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(meadow: meadow)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
            
        case .area(let meadow):
            
            guard let viewController = viewController as? AreaUtilitiesViewController else { break }
            
            viewController.viewModel.state = .area(meadow: meadow)
            
        case .foliage(let meadow):
            
            guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
            
            viewController.viewModel.state = .foliage(meadow: meadow)
            
        case .footpath(let meadow):
            
            guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
            
            viewController.viewModel.state = .footpath(meadow: meadow)
            
        case .terrain(let meadow):
            
            guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
            
            viewController.viewModel.state = .terrain(meadow: meadow)
            
        case .water(let meadow):
            
            guard let viewController = viewController as? WaterUtilitiesViewController else { break }
            
            viewController.viewModel.state = .water(meadow: meadow)
            
        default: break
        }
    }
}

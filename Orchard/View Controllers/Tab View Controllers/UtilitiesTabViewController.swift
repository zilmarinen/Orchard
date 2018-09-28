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
        
        return UtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension UtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension UtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        if let from = from {
            
            let viewController = children[from.sortOrder]
            
            switch from {
                
            case .area(let editor, _):
                
                guard let viewController = viewController as? AreaUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .foliage(let editor, _):
                
                guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .footpath(let editor, _):
                
                guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .terrain(let editor, _):
                
                guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .water(let editor, _):
                
                guard let viewController = viewController as? WaterUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
            
        case .area(let editor, let grid):
            
            guard let viewController = viewController as? AreaUtilitiesViewController else { break }
            
            viewController.viewModel.state = .area(editor: editor, grid: grid)
            
        case .foliage(let editor, let grid):
            
            guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
            
            viewController.viewModel.state = .foliage(editor: editor, grid: grid)
            
        case .footpath(let editor, let grid):
            
            guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
            
            viewController.viewModel.state = .footpath(editor: editor, grid: grid)
            
        case .terrain(let editor, let grid):
            
            guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
            
            viewController.viewModel.state = .terrain(editor: editor, grid: grid)
            
        case .water(let editor, let grid):
            
            guard let viewController = viewController as? WaterUtilitiesViewController else { break }
            
            viewController.viewModel.state = .water(editor: editor, grid: grid)
            
        default: break
        }
    }
}

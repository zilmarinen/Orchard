//
//  AreaUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class AreaUtilitiesTabViewController: NSTabViewController {
    
    lazy var viewModel = {
        
        return AreaUtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension AreaUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        if let from = from {
            
            let viewController = children[from.sortOrder]
            
            switch from {
                
            case .build(let editor):
                
                guard let viewController = viewController as? AreaBuildUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .architecture(let editor):
                
                guard let viewController = viewController as? AreaArchitectureUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            case .paint(let editor):
                
                guard let viewController = viewController as? AreaPaintUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
            
        case .build(let editor):
            
            guard let viewController = viewController as? AreaBuildUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                let utility = AreaBuildUtility(colorPalette: colorPalette, other: colorPalette)
                
                viewController.viewModel.state = .build(editor: editor, utility: utility)
                
            default: break
            }
            
        case .architecture(let editor):
            
            guard let viewController = viewController as? AreaArchitectureUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                let utility = AreaArchitectureUtility(colorPalette: editor, other: editor)
                
                viewController.viewModel.state = .architecture(editor: editor, utility: utility)
                
            default: break
            }
            
        case .paint(let editor):
        
            guard let viewController = viewController as? AreaPaintUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                let utility = AreaPaintUtility(floorColorPalette: colorPalette, externalColorPalette: colorPalette, internalColorPalette: colorPalette)
                
                viewController.viewModel.state = .paint(editor: editor, utility: utility)
                
            default: break
            }
            
        default: break
        }
    }
}

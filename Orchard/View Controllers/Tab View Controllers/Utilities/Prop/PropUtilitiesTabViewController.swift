//
//  PropUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class PropUtilitiesTabViewController: NSTabViewController {
    
    lazy var viewModel = {
        
        return PropUtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension PropUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        if let from = from {
            
            let viewController = children[from.sortOrder]
            
            switch from {
                
            case .build(let editor):
                
                guard let viewController = viewController as? PropBuildUtilitiesViewController else { break }
                
                viewController.viewModel.state = .empty(editor: editor)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
            
        case .build(let editor):
            
            guard let viewController = viewController as? PropBuildUtilitiesViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                guard let prop = PropsMaster.shared?.props.child(at: 0), let colorPalette = ArtDirector.shared?.palettes.child(at: 0) else { break }
                
                let utility = PropBuildUtility(prop: prop, colorPalette: colorPalette)
                
                viewController.viewModel.state = .build(editor: editor, utility: utility)
                
            default: break
            }
            
        default: break
        }
    }
}

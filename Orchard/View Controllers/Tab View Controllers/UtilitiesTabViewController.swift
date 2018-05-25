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
        
        return UtilitiesTabViewModel(initialState: .empty)
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
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        case .terrain(let terrain):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainUtilitiesViewController else { break }
            
            viewController.viewModel.state = .inspecting(terrain)
            
        default: break
        }
    }
}

//
//  TerrainUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

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
    }
}

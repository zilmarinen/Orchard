//
//  WaterUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class WaterUtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return WaterUtilitiesTabViewModel(initialState: .empty)
    }()
}

extension WaterUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension WaterUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        default: break
        }
    }
}

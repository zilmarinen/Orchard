//
//  FoliageUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class FoliageUtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return FoliageUtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension FoliageUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FoliageUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        default: break
        }
    }
}

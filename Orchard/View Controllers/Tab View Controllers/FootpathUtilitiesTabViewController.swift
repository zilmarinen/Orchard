//
//  FootpathUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class FootpathUtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return FootpathUtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension FootpathUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension FootpathUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        default: break
        }
    }
}

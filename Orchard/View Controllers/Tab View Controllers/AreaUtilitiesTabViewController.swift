//
//  AreaUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class AreaUtilitiesTabViewController: NSTabViewController {
    
    lazy var viewModel = {
        
        return AreaUtilitiesTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension AreaUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension AreaUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {

        default: break
        }
    }
}

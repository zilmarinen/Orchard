//
//  UtilityTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class UtilityTabViewController: NSTabViewController {

    weak var coordinator: UtilityTabViewCoordinator?

    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension UtilityTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
         
            self.selectedTabViewItemIndex = to.tab.rawValue
        }
    }
}


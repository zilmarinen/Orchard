//
//  SidebarTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class SidebarTabViewController: NSTabViewController {
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return children.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
    }
    
    var utilitiesTabViewController: UtilitiesTabViewController? {
        
        return children.first { return type(of: $0) == UtilitiesTabViewController.self } as? UtilitiesTabViewController
    }

    lazy var viewModel = {
        
        return SidebarTabViewModel(initialState: .empty)
    }()
}

extension SidebarTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SidebarTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        guard let inspectorTabViewController = inspectorTabViewController, let utilitiesTabViewController = utilitiesTabViewController else { return }
        
        selectedTabViewItemIndex = to.tab.rawValue
        
        switch to {
            
        case .empty:
            
            inspectorTabViewController.viewModel.state = .empty
            utilitiesTabViewController.viewModel.state = .empty
            
        case .inspector(let meadow),
             .utilities(let meadow):
            
            inspectorTabViewController.viewModel.state = .scene(meadow)
            utilitiesTabViewController.viewModel.state = .empty
        }
    }
}

//
//  SidebarTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class SidebarTabViewController: NSTabViewController {
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return childViewControllers.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
    }
    
    var utilitiesTabViewController: UtilitiesTabViewController? {
        
        return childViewControllers.first { return type(of: $0) == UtilitiesTabViewController.self } as? UtilitiesTabViewController
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
        
        selectedTabViewItemIndex = to.sortOrder
        
        switch to {
            
        case .inspector(let meadow):
            
            guard let viewController = inspectorTabViewController else { break }
            
            switch viewController.viewModel.state {
                
            case .empty:
                
                viewController.viewModel.state = .scene(meadow)
                
            default:
                
                viewController.viewModel.state = viewController.viewModel.state
            }
            
        case .utilities:
            
            guard let viewController = utilitiesTabViewController else { break }
            
            viewController.viewModel.state = viewController.viewModel.state
            
        default: break
        }
    }
}

//
//  SidebarTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class SidebarTabViewController: NSTabViewController {
    
    weak var coordinator: SidebarTabViewCoordinator?
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return children.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
    }
    
    var utilityTabViewController: UtilityTabViewController? {
        
        return children.first { return type(of: $0) == UtilityTabViewController.self } as? UtilityTabViewController
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SidebarTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty:
                
                self.selectedTabViewItemIndex = to.tab.rawValue
                
            case .inspector(let node):
                
                self.selectedTabViewItemIndex = to.tab.rawValue
                
                self.utilityTabViewController?.viewModel.clear()
                
                self.inspectorTabViewController?.viewModel.select(node: node)
                
            case .utility(let node):
                
                self.selectedTabViewItemIndex = to.tab.rawValue
                
                self.inspectorTabViewController?.viewModel.clear()
                
                self.utilityTabViewController?.viewModel.select(node: node)
            }
        }
    }
}

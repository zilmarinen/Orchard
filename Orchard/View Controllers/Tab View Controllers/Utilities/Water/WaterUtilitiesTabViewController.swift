//
//  WaterUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class WaterUtilitiesTabViewController: NSTabViewController {

    lazy var viewModel = {
        
        return WaterUtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension WaterUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor):
                    
                    guard let viewController = viewController as? WaterBuildUtilitiesViewController else { break }
                    
                    viewController.viewModel.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor):
                
                guard let viewController = viewController as? WaterBuildUtilitiesViewController else { break }
                
                switch viewController.viewModel.state {
                    
                case .empty:
                    
                    viewController.viewModel.state = .build(editor: editor, tool: (toolType: .tile, waterType: WaterType.water))
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

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
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor):
                    
                    guard let viewController = viewController as? FoliageBuildUtilitiesViewController else { break }
                    
                    viewController.viewModel.state = .empty(editor: editor)
                    
                case .paint(let editor):
                    
                    guard let viewController = viewController as? FoliagePaintUtilitiesViewController else { break }
                    
                    viewController.viewModel.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor):
                
                guard let viewController = viewController as? FoliageBuildUtilitiesViewController else { break }
                
                switch viewController.viewModel.state {
                    
                case .empty:
                    
                    viewController.viewModel.state = .build(editor: editor)
                    
                default: break
                }
                
            case .paint(let editor):
                
                guard let viewController = viewController as? FoliagePaintUtilitiesViewController else { break }
                
                switch viewController.viewModel.state {
                    
                case .empty:
                    
                    viewController.viewModel.state = .paint(editor: editor)
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

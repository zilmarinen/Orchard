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
        
        return FootpathUtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension FootpathUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FootpathUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor, _):
                    
                    guard let viewController = viewController as? FootpathBuildUtilitiesViewController else { break }
                    
                    viewController.viewModel.state = .empty(editor: editor)
                    
                case .paint(let editor, _):
                    
                    guard let viewController = viewController as? FootpathPaintUtilitiesViewController else { break }
                    
                    viewController.viewModel.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor, let tool):
                
                guard let viewController = viewController as? FootpathBuildUtilitiesViewController else { break }
                
                switch viewController.viewModel.state {
                    
                case .empty:
                    
                    viewController.viewModel.state = .build(editor: editor, tool: tool)
                    
                default: break
                }
                
            case .paint(let editor, let tool):
                
                guard let viewController = viewController as? FootpathPaintUtilitiesViewController else { break }
                
                switch viewController.viewModel.state {
                    
                case .empty:
                    
                    viewController.viewModel.state = .paint(editor: editor, tool: tool)
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

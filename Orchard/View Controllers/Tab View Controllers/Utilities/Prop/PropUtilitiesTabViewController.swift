//
//  PropUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class PropUtilitiesTabViewController: NSTabViewController {
    
    lazy var stateObserver = {
        
        return PropUtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension PropUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension PropUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor):
                    
                    guard let viewController = viewController as? PropBuildUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor):
                
                guard let viewController = viewController as? PropBuildUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    guard let propList = PropsMaster.shared?.lists.children.first, let prop = propList.child(at: 0), let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    viewController.stateObserver.state = .build(editor: editor, tool: (propType: propList.type, propList: propList, prop: prop, rotation: .north, colorPalette: colorPalette))
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

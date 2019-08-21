//
//  TerrainUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class TerrainUtilitiesTabViewController: NSTabViewController {

    lazy var stateObserver = {
        
        return TerrainUtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension TerrainUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor):
                    
                    guard let viewController = viewController as? TerrainBuildUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .terraform(let editor):
                    
                    guard let viewController = viewController as? TerrainTerraformUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .paint(let editor):
                    
                    guard let viewController = viewController as? TerrainPaintUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor):
                
                guard let viewController = viewController as? TerrainBuildUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    viewController.stateObserver.state = .build(editor: editor, tool: (toolType: .tile, terrainType: TerrainType.bedrock))
                    
                default: break
                }
                
            case .terraform(let editor):
                
                guard let viewController = viewController as? TerrainTerraformUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    viewController.stateObserver.state = .terraform(editor: editor, tool: (toolType: .edge, reticule: (1, 1)))
                    
                default: break
                }
            
            case .paint(let editor):
                
                guard let viewController = viewController as? TerrainPaintUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    viewController.stateObserver.state = .paint(editor: editor, tool: (toolType: .edge, terrainType: TerrainType.bedrock))
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

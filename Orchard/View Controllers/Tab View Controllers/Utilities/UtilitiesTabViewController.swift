//
//  UtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class UtilitiesTabViewController: NSTabViewController {

    lazy var stateObserver = {
        
        return UtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension UtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension UtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .area(let editor):
                    
                    guard let viewController = viewController as? AreaUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .foliage(let editor):
                    
                    guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .footpath(let editor):
                    
                    guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .prop(let editor):
                    
                    guard let viewController = viewController as? PropUtilitiesViewController else { break}
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .terrain(let editor):
                    
                    guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .water(let editor):
                    
                    guard let viewController = viewController as? WaterUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .area(let editor):
                
                guard let viewController = viewController as? AreaUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .area(editor: editor)
                
            case .foliage(let editor):
                
                guard let viewController = viewController as? FoliageUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .foliage(editor: editor)
                
            case .footpath(let editor):
                
                guard let viewController = viewController as? FootpathUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .footpath(editor: editor)
                
            case .prop(let editor):
                
                guard let viewController = viewController as? PropUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .area(editor: editor)
                
            case .terrain(let editor):
                
                guard let viewController = viewController as? TerrainUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .terrain(editor: editor)
                
            case .water(let editor):
                
                guard let viewController = viewController as? WaterUtilitiesViewController else { break }
                
                viewController.stateObserver.state = .water(editor: editor)
                
            default: break
            }
        }
    }
}

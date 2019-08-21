//
//  AreaUtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class AreaUtilitiesTabViewController: NSTabViewController {
    
    lazy var stateObserver = {
        
        return AreaUtilitiesTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension AreaUtilitiesTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension AreaUtilitiesTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            if let from = from {
                
                let viewController = self.children[from.sortOrder]
                
                switch from {
                    
                case .build(let editor):
                    
                    guard let viewController = viewController as? AreaBuildUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .architecture(let editor):
                    
                    guard let viewController = viewController as? AreaArchitectureUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                case .paint(let editor):
                    
                    guard let viewController = viewController as? AreaPaintUtilitiesViewController else { break }
                    
                    viewController.stateObserver.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.sortOrder
            
            let viewController = self.children[to.sortOrder]
            
            switch to {
                
            case .build(let editor):
                
                guard let viewController = viewController as? AreaBuildUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    let floor = AreaNodeFloor(colorPalette: colorPalette, floorType: .plain)
                    
                    let internalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: .concrete)
                    let externalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: .concrete)
                    
                    viewController.stateObserver.state = .build(editor: editor, tool: (externalEdges: true, edgeType: AreaNodeEdgeType.wall, floor: floor, internalEdgeFace: internalEdgeFace, externalEdgeFace: externalEdgeFace))
                    
                default: break
                }
                
            case .architecture(let editor):
                
                guard let viewController = viewController as? AreaArchitectureUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    let utility = AreaArchitectureUtility(colorPalette: editor, other: editor)
                    
                    viewController.stateObserver.state = .architecture(editor: editor, utility: utility)
                    
                default: break
                }
                
            case .paint(let editor):
            
                guard let viewController = viewController as? AreaPaintUtilitiesViewController else { break }
                
                switch viewController.stateObserver.state {
                    
                case .empty:
                    
                    guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    let utility = AreaPaintUtility(floorColorPalette: colorPalette, externalColorPalette: colorPalette, internalColorPalette: colorPalette)
                    
                    viewController.stateObserver.state = .paint(editor: editor, utility: utility)
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

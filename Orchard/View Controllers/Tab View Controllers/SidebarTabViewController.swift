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
        
        return SidebarTabViewModel(initialState: .empty(editor: nil))
    }()
}

extension SidebarTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SidebarTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        guard let inspectorTabViewController = inspectorTabViewController, let utilitiesTabViewController = utilitiesTabViewController else { return }
        
        if let from = from {
            
            switch from {
                
            case .utility(let meadow):
                
                utilitiesTabViewController.viewModel.state = .empty(meadow: meadow)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.tab.rawValue
        
        switch to {
            
        case .empty(let editor):
            
            inspectorTabViewController.viewModel.state = .empty
            utilitiesTabViewController.viewModel.state = .empty(meadow: editor?.meadow)
            
        case .inspector(let editor, let child):
            
            switch type(of: child) {

            case is Area.Type,
                 is AreaChunk.Type,
                 is AreaTile.Type,
                 is AreaNode.Type:
                
                inspectorTabViewController.viewModel.state = .area(editor: editor, inspectable: (editor.meadow.scene.world.areas, child as? AreaChunk, child as? AreaTile, child as? AreaNode, .north))
                
            case is Foliage.Type,
                 is FoliageChunk.Type,
                 is FoliageTile.Type,
                 is FoliageNode.Type:
                
                inspectorTabViewController.viewModel.state = .foliage(editor: editor, inspectable: (editor.meadow.scene.world.foliage, child as? FoliageChunk, child as? FoliageTile, child as? FoliageNode))
                
            case is Footpath.Type,
                 is FootpathChunk.Type,
                 is FootpathTile.Type,
                 is FootpathNode.Type:
                
                inspectorTabViewController.viewModel.state = .footpath(editor: editor, inspectable: (editor.meadow.scene.world.footpaths, child as? FootpathChunk, child as? FootpathTile, child as? FootpathNode))
                
            case is Terrain.Type,
                 is TerrainChunk.Type,
                 is TerrainTile.Type,
                 is TerrainNode<TerrainLayer>.Type,
                 is TerrainLayer.Type:
                
                inspectorTabViewController.viewModel.state = .terrain(editor: editor, inspectable: (editor.meadow.scene.world.terrain, child as? TerrainChunk, child as? TerrainTile, child as? TerrainNode<TerrainLayer>, child as? TerrainLayer, .north))
                
            case is Water.Type,
                 is WaterChunk.Type,
                 is WaterTile.Type,
                 is WaterNode.Type:
                
                inspectorTabViewController.viewModel.state = .water(editor: editor, inspectable: (editor.meadow.scene.world.water, child as? WaterChunk, child as? WaterTile, child as? WaterNode))
                
            case is Scene.Type:
                
                inspectorTabViewController.viewModel.state = .scene(editor: editor)
                
            default:
                
                inspectorTabViewController.viewModel.state = .empty
            }
            
        case .utility(let meadow):
            
            switch inspectorTabViewController.viewModel.state {
            
            case .area:
                
                utilitiesTabViewController.viewModel.state = .area(meadow: meadow)
                
            case .foliage:
                
                utilitiesTabViewController.viewModel.state = .foliage(meadow: meadow)
                
            case .footpath:
                
                utilitiesTabViewController.viewModel.state = .footpath(meadow: meadow)
                
            case .terrain:
                
                utilitiesTabViewController.viewModel.state = .terrain(meadow: meadow)
                
            case .water:
                
                utilitiesTabViewController.viewModel.state = .water(meadow: meadow)
                
            default:
                
                utilitiesTabViewController.viewModel.state = .empty(meadow: meadow)
            }
        }
    }
}

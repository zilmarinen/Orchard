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
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SidebarTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        guard let inspectorTabViewController = inspectorTabViewController, let utilitiesTabViewController = utilitiesTabViewController else { return }
        
        if let from = from {
            
            switch from {
                
            case .utility(let editor, _):
                
                utilitiesTabViewController.viewModel.state = .empty(editor: editor)
                
            default: break
            }
        }
        
        selectedTabViewItemIndex = to.tab.rawValue
        
        switch to {
            
        case .empty(let editor):
            
            inspectorTabViewController.viewModel.state = .empty
            utilitiesTabViewController.viewModel.state = .empty(editor: editor)
            
        case .inspector(let editor, let child):
            
            switch type(of: child) {

            case is Area.Type,
                 is AreaChunk.Type,
                 is AreaTile.Type,
                 is AreaNode.Type:
                
                inspectorTabViewController.viewModel.state = .area(editor: editor, inspectable: (editor.meadow.world.areas, child as? AreaChunk, child as? AreaTile, child as? AreaNode, .north))
                
            case is Foliage.Type,
                 is FoliageChunk.Type,
                 is FoliageTile.Type,
                 is FoliageNode.Type:
                
                inspectorTabViewController.viewModel.state = .foliage(editor: editor, inspectable: (editor.meadow.world.foliage, child as? FoliageChunk, child as? FoliageTile, child as? FoliageNode))
                
            case is Footpath.Type,
                 is FootpathChunk.Type,
                 is FootpathTile.Type,
                 is FootpathNode.Type:
                
                inspectorTabViewController.viewModel.state = .footpath(editor: editor, inspectable: (editor.meadow.world.footpaths, child as? FootpathChunk, child as? FootpathTile, child as? FootpathNode))
                
            case is Terrain.Type,
                 is TerrainChunk.Type,
                 is TerrainTile.Type,
                 is TerrainNode<TerrainLayer>.Type,
                 is TerrainLayer.Type:
                
                inspectorTabViewController.viewModel.state = .terrain(editor: editor, inspectable: (editor.meadow.world.terrain, child as? TerrainChunk, child as? TerrainTile, child as? TerrainNode<TerrainLayer>, child as? TerrainLayer, .north))
                
            case is Water.Type,
                 is WaterChunk.Type,
                 is WaterTile.Type,
                 is WaterNode.Type:
                
                inspectorTabViewController.viewModel.state = .water(editor: editor, inspectable: (editor.meadow.world.water, child as? WaterChunk, child as? WaterTile, child as? WaterNode))
                
            case is Meadow.Type:
                
                inspectorTabViewController.viewModel.state = .scene(editor: editor)
                
            default:
                
                inspectorTabViewController.viewModel.state = .empty
            }
            
        case .utility(let editor, _):
            
            switch inspectorTabViewController.viewModel.state {
            
            case .area(let editor, let inspectable):
                
                utilitiesTabViewController.viewModel.state = .area(editor: editor, grid: inspectable.grid)
                
            case .foliage(_, let inspectable):
                
                utilitiesTabViewController.viewModel.state = .foliage(editor: editor, grid: inspectable.grid)
                
            case .footpath(_, let inspectable):
                
                utilitiesTabViewController.viewModel.state = .footpath(editor: editor, grid: inspectable.grid)
                
            case .terrain(_, let inspectable):
                
                utilitiesTabViewController.viewModel.state = .terrain(editor: editor, grid: inspectable.grid)
                
            case .water(_, let inspectable):
                
                utilitiesTabViewController.viewModel.state = .water(editor: editor, grid: inspectable.grid)
                
            default:
                
                utilitiesTabViewController.viewModel.state = .empty(editor: editor)
            }
        }
    }
}

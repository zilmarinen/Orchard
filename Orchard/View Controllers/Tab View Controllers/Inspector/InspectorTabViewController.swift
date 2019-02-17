//
//  InspectorTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class InspectorTabViewController: NSTabViewController {
    
    lazy var viewModel = {
        
        return InspectorTabViewModel(initialState: .empty)
    }()
}

extension InspectorTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension InspectorTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
        
        case .area(let editor, var inspectable):
            
            guard let viewController = viewController as? AreaInspectorViewController else { break }
            
            if let chunk = inspectable.chunk, chunk.totalChildren > 0 {
                
                inspectable.tile = chunk.child(at: 0) as? AreaTile
            }
            
            if let tile = inspectable.tile, tile.totalChildren > 0 {
                
                inspectable.node = tile.child(at: 0) as? AreaNode
            }
            
            if let node = inspectable.node {
                
                inspectable.tile = node.observer as? AreaTile
                inspectable.chunk = inspectable.tile?.observer as? AreaChunk
            }
            
            viewController.viewModel.state = .area(editor: editor, inspectable: inspectable)
            
        case .foliage(let editor, var inspectable):
            
            guard let viewController = viewController as? FoliageInspectorViewController else { break }
            
            if let chunk = inspectable.chunk, chunk.totalChildren > 0 {
                
                inspectable.tile = chunk.child(at: 0) as? FoliageTile
            }
            
            if let tile = inspectable.tile, tile.totalChildren > 0 {
                
                inspectable.node = tile.child(at: 0) as? FoliageNode
            }
            
            if let node = inspectable.node {
                
                inspectable.tile = node.observer as? FoliageTile
                inspectable.chunk = inspectable.tile?.observer as? FoliageChunk
            }
            
            viewController.viewModel.state = .foliage(editor: editor, inspectable: inspectable)
            
        case .footpath(let editor, var inspectable):
            
            guard let viewController = viewController as? FootpathInspectorViewController else { break }
            
            if let chunk = inspectable.chunk, chunk.totalChildren > 0 {
                
                inspectable.tile = chunk.child(at: 0) as? FootpathTile
            }
            
            if let tile = inspectable.tile, tile.totalChildren > 0 {
                
                inspectable.node = tile.child(at: 0) as? FootpathNode
            }
            
            if let node = inspectable.node {
                
                inspectable.tile = node.observer as? FootpathTile
                inspectable.chunk = inspectable.tile?.observer as? FootpathChunk
            }
            
            viewController.viewModel.state = .footpath(editor: editor, inspectable: inspectable)
            
        case .prop(let editor, let inspectable):
            
            guard let viewController = viewController as? PropInspectorViewController else { break }
            
            viewController.viewModel.state = .prop(editor: editor, inspectable: inspectable)
            
        case.scene(let editor):
            
            guard let viewController = viewController as? SceneInspectorViewController else { break }
            
            viewController.viewModel.state = .scene(editor: editor)
            
        case.terrain(let editor, var inspectable):
            
            guard let viewController = viewController as? TerrainInspectorViewController else { break }
            
            if let chunk = inspectable.chunk, chunk.totalChildren > 0 {
                
                inspectable.tile = chunk.child(at: 0) as? TerrainTile
            }
            
            if let tile = inspectable.tile, tile.totalChildren > 0 {
                
                inspectable.node = tile.child(at: 0) as? TerrainNode
            }
            
            if let node = inspectable.node, node.totalChildren > 0 {
                
                inspectable.edge = node.child(at: 0) as? TerrainNodeEdge
            }
            
            if let edge = inspectable.edge, edge.totalChildren > 0 {
                
                inspectable.layer = edge.child(at: 0) as? TerrainEdgeLayer
            }
            
            if let layer = inspectable.layer {
                
                inspectable.edge = layer.observer as? TerrainNodeEdge
                inspectable.node = inspectable.edge?.observer as? TerrainNode
                inspectable.tile = inspectable.node?.observer as? TerrainTile
                inspectable.chunk = inspectable.tile?.observer as? TerrainChunk
            }
            
            viewController.viewModel.state = .terrain(editor: editor, inspectable: inspectable)
            
        case .water(let editor, var inspectable):
            
            guard let viewController = viewController as? WaterInspectorViewController else { break }
            
            if let chunk = inspectable.chunk, chunk.totalChildren > 0 {
                
                inspectable.tile = chunk.child(at: 0) as? WaterTile
            }
            
            if let tile = inspectable.tile, tile.totalChildren > 0 {
                
                inspectable.node = tile.child(at: 0) as? WaterNode
            }
            
            if let node = inspectable.node {
                
                inspectable.tile = node.observer as? WaterTile
                inspectable.chunk = inspectable.tile?.observer as? WaterChunk
            }
            
            if let edge = inspectable.edge {
                
                inspectable.node = edge.observer as? WaterNode
                inspectable.tile = inspectable.node?.observer as? WaterTile
                inspectable.chunk = inspectable.tile?.observer as? WaterChunk
            }
            
            viewController.viewModel.state = .water(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
}

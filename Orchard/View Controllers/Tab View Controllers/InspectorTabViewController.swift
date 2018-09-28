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
        
        viewModel.subscribe(stateDidChange)
    }
}

extension InspectorTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        selectedTabViewItemIndex = to.sortOrder
        
        let viewController = children[to.sortOrder]
        
        switch to {
        
        case .area(let delegate, let area, var chunk, var tile, var node):
            
            guard let viewController = viewController as? AreaInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? AreaTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? AreaNode
            }
            
            if let node = node {
                
                tile = node.observer as? AreaTile
                chunk = tile?.observer as? AreaChunk
            }
            
            var inspectable: (AreaChunk, AreaTile, AreaNode, GridEdge)?
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                inspectable = (chunk, tile, node, .north)
            }
            
            viewController.viewModel.state = .inspecting(delegate, area, inspectable)
            
        case .camera(let cameraJib):
            
            guard let viewController = viewController as? CameraInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(cameraJib)
            
        case .foliage(let delegate, let foliage, var chunk, var tile, var node):
            
            guard let viewController = viewController as? FoliageInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? FoliageTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? FoliageNode
            }
            
            if let node = node {
                
                tile = node.observer as? FoliageTile
                chunk = tile?.observer as? FoliageChunk
            }
            
            var inspectable: (FoliageChunk, FoliageTile, FoliageNode)?
            
            if let chunk = chunk, let tile = tile, let node = node {
            
                inspectable = (chunk, tile, node)
            }
            
            viewController.viewModel.state = .inspecting(delegate, foliage, inspectable)
            
        case .footpath(let delegate, let footpath, var chunk, var tile, var node):
            
            guard let viewController = viewController as? FootpathInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? FootpathTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? FootpathNode
            }
            
            if let node = node {
                
                tile = node.observer as? FootpathTile
                chunk = tile?.observer as? FootpathChunk
            }
            
            var inspectable: (FootpathChunk, FootpathTile, FootpathNode)?
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                inspectable = (chunk, tile, node)
            }
            
            viewController.viewModel.state = .inspecting(delegate, footpath, inspectable)
            
        case.scene(let meadow):
            
            guard let viewController = viewController as? SceneInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(meadow)
            
        case.terrain(let delegate, let terrain, var chunk, var tile, var node, var layer):
            
            guard let viewController = viewController as? TerrainInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? TerrainTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? TerrainNode
            }
            
            if let node = node, node.totalChildren > 0 {
                
                layer = node.child(at: 0) as? TerrainLayer
            }
            
            if let layer = layer {
                
                node = layer.observer as? TerrainNode
                tile = node?.observer as? TerrainTile
                chunk = tile?.observer as? TerrainChunk
            }
            
            var inspectable: (TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>, TerrainLayer, GridEdge)?
            
            if let chunk = chunk, let tile = tile, let node = node, let layer = layer {
                
                inspectable = (chunk, tile, node, layer, .north)
            }
            
            viewController.viewModel.state = .inspecting(delegate, terrain, inspectable)
            
        case .water(let delegate, let water, var chunk, var tile, var node):
            
            guard let viewController = viewController as? WaterInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? WaterTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? WaterNode
            }
            
            if let node = node {
                
                tile = node.observer as? WaterTile
                chunk = tile?.observer as? WaterChunk
            }
            
            var inspectable: (WaterChunk, WaterTile, WaterNode)?
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                inspectable = (chunk, tile, node)
            }
            
            viewController.viewModel.state = .inspecting(delegate, water, inspectable)
            
        case .world(let world):
            
            guard let viewController = viewController as? WorldInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(world)
            
        default: break
        }
    }
}

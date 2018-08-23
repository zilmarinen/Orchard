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
        
        switch to {
        
        case .area(let area, var chunk, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? AreaInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? AreaTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? AreaNode
            }
            
            if let node = node {
                
                tile = area.find(tile: node.volume.coordinate)
                chunk = area.find(chunk: node.volume.coordinate)
            }
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(area, (chunk, tile, node, .north))
            }
            else {
                
                viewController.viewModel.state = .inspecting(area, nil)
            }
            
        case .camera(let cameraJib):
            
            guard let viewController = childViewControllers[to.sortOrder] as? CameraInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(cameraJib)
            
        case .foliage(let foliage, var chunk, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FoliageInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? FoliageTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? FoliageNode
            }
            
            if let node = node {
                
                tile = foliage.find(tile: node.volume.coordinate)
                chunk = foliage.find(chunk: node.volume.coordinate)
            }
            
            if let chunk = chunk, let tile = tile, let node = node {
            
                viewController.viewModel.state = .inspecting(foliage, (chunk, tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(foliage, nil)
            }
            
        case .footpath(let footpath, var chunk, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FootpathInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? FootpathTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? FootpathNode
            }
            
            if let node = node {
                
                tile = footpath.find(tile: node.volume.coordinate)
                chunk = footpath.find(chunk: node.volume.coordinate)
            }
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(footpath, (chunk, tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(footpath, nil)
            }
            
        case.scene(let meadow):
            
            guard let viewController = childViewControllers[to.sortOrder] as? SceneInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(meadow)
            
        case.terrain(let terrain, var chunk, var tile, var node, var layer):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? TerrainTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? TerrainNode
            }
            
            if let node = node, node.totalChildren > 0 {
                
                layer = node.child(at: 0) as? TerrainLayer
            }
            
            if let layer = layer, let observer = layer.observer as? TerrainNode {
                
                node = observer
                tile = terrain.find(tile: observer.volume.coordinate)
                chunk = terrain.find(chunk: observer.volume.coordinate)
            }
            
            switch viewController.viewModel.state {
                
            case .empty:
             
                if let chunk = chunk, let tile = tile, let node = node, let layer = layer {
                    
                    viewController.viewModel.state = .inspecting(terrain, (chunk, tile, node, layer, .north))
                }
                else {
                    
                    viewController.viewModel.state = .inspecting(terrain, nil)
                }
                
            case .inspecting(_, _):
                
                if let chunk = chunk, let tile = tile, let node = node, let layer = layer {
                    
                    viewController.viewModel.state = .inspecting(terrain, (chunk, tile, node, layer, .north))
                }
                else {
                    
                    viewController.viewModel.state = .inspecting(terrain, nil)
                }
            }
            
        case .water(let water, var chunk, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? WaterInspectorViewController else { break }
            
            if let chunk = chunk, chunk.totalChildren > 0 {
                
                tile = chunk.child(at: 0) as? WaterTile
            }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.child(at: 0) as? WaterNode
            }
            
            if let node = node {
                
                tile = water.find(tile: node.volume.coordinate)
                chunk = water.find(chunk: node.volume.coordinate)
            }
            
            if let chunk = chunk, let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(water, (chunk, tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(water, nil)
            }
            
        default: break
        }
    }
}

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
        
        case .area(let area, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? AreaInspectorViewController else { break }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.sceneGraph(childAtIndex: 0) as? AreaNode
            }
            else if let node = node {
                
                tile = area.find(tile: node.volume.coordinate)
            }
            
            if let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(area, (tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(area, nil)
            }
            
        case .camera(let cameraJib):
            
            guard let viewController = childViewControllers[to.sortOrder] as? CameraInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(cameraJib)
            
        case .foliage(let foliage, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FoliageInspectorViewController else { break }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.sceneGraph(childAtIndex: 0) as? FoliageNode
            }
            else if let node = node {
                
                tile = foliage.find(tile: node.volume.coordinate)
            }
            
            if let tile = tile, let node = node {
            
                viewController.viewModel.state = .inspecting(foliage, (tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(foliage, nil)
            }
            
        case .footpath(let footpath, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? FootpathInspectorViewController else { break }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.sceneGraph(childAtIndex: 0) as? FootpathNode
            }
            else if let node = node {
                
                tile = footpath.find(tile: node.volume.coordinate)
            }
            
            if let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(footpath, (tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(footpath, nil)
            }
            
        case.scene(let meadow):
            
            guard let viewController = childViewControllers[to.sortOrder] as? SceneInspectorViewController else { break }
            
            viewController.viewModel.state = .inspecting(meadow)
            
        case.terrain(let terrain, var tile, var node, var layer):
            
            guard let viewController = childViewControllers[to.sortOrder] as? TerrainInspectorViewController else { break }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.sceneGraph(childAtIndex: 0) as? TerrainNode
            }
            
            if let node = node, node.totalChildren > 0 {
                
                layer = node.sceneGraph(childAtIndex: 0) as? TerrainLayer
            }
            
            if let layer = layer {
                
                node = layer.node
                tile = terrain.find(tile: node!.volume.coordinate)
            }
            
            if let tile = tile, let node = node, let layer = layer {
             
                viewController.viewModel.state = .inspecting(terrain, (tile, node, layer))
            }
            else {
                
                viewController.viewModel.state = .inspecting(terrain, nil)
            }
            
        case .water(let water, var tile, var node):
            
            guard let viewController = childViewControllers[to.sortOrder] as? WaterInspectorViewController else { break }
            
            if let tile = tile, tile.totalChildren > 0 {
                
                node = tile.sceneGraph(childAtIndex: 0) as? WaterNode
            }
            else if let node = node {
                
                tile = water.find(tile: node.volume.coordinate)
            }
            
            if let tile = tile, let node = node {
                
                viewController.viewModel.state = .inspecting(water, (tile, node))
            }
            else {
                
                viewController.viewModel.state = .inspecting(water, nil)
            }
            
        default: break
        }
    }
}

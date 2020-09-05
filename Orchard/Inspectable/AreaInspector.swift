//
//  AreaInspector.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct AreaInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: (grid: Area, chunk: AreaChunk?, tile: AreaTile?, edge: AreaEdge?, layer: AreaLayer?)
    
    init?(node: SceneGraphIdentifiable) {
        
        guard node.category == .area else { return nil }
        
        self.node = node
        
        switch node.type {
            
        case .grid:
            
            guard let Area = node as? Area else { return nil }
            
            self.inspectable = (grid: Area, chunk: nil, tile: nil, edge: nil, layer: nil)
            
        case .chunk:
            
            guard let chunk = node as? AreaChunk, let Area = chunk.ancestor as? Area else { return nil }
            
            self.inspectable = (grid: Area, chunk: chunk, tile: nil, edge: nil, layer: nil)
            
        case .tile:
            
            guard let tile = node as? AreaTile, let chunk = tile.ancestor as? AreaChunk, let Area = chunk.ancestor as? Area else { return nil }
            
            let edge = tile.children.first as? AreaEdge
            let layer = edge?.children.last as? AreaLayer
            
            self.inspectable = (grid: Area, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .edge:
            
            guard let edge = node as? AreaEdge, let tile = edge.ancestor as? AreaTile, let chunk = tile.ancestor as? AreaChunk, let Area = chunk.ancestor as? Area else { return nil }
            
            let layer = edge.children.last as? AreaLayer
            
            self.inspectable = (grid: Area, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .layer:
            
            guard let layer = node as? AreaLayer, let edge = layer.ancestor as? AreaEdge, let tile = edge.ancestor as? AreaTile, let chunk = tile.ancestor as? AreaChunk, let Area = chunk.ancestor as? Area else { return nil }
            
            self.inspectable = (grid: Area, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        default: return nil
        }
    }
}



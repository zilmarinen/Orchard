//
//  WaterInspector.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct WaterInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: (grid: Water, chunk: WaterChunk?, tile: WaterTile?, edge: WaterEdge?, layer: WaterLayer?)
    
    init?(node: SceneGraphIdentifiable) {
        
        guard node.category == .water else { return nil }
        
        self.node = node
        
        switch node.type {
            
        case .grid:
            
            guard let Water = node as? Water else { return nil }
            
            self.inspectable = (grid: Water, chunk: nil, tile: nil, edge: nil, layer: nil)
            
        case .chunk:
            
            guard let chunk = node as? WaterChunk, let Water = chunk.ancestor as? Water else { return nil }
            
            self.inspectable = (grid: Water, chunk: chunk, tile: nil, edge: nil, layer: nil)
            
        case .tile:
            
            guard let tile = node as? WaterTile, let chunk = tile.ancestor as? WaterChunk, let Water = chunk.ancestor as? Water else { return nil }
            
            let edge = tile.children.first as? WaterEdge
            let layer = edge?.children.last as? WaterLayer
            
            self.inspectable = (grid: Water, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .edge:
            
            guard let edge = node as? WaterEdge, let tile = edge.ancestor as? WaterTile, let chunk = tile.ancestor as? WaterChunk, let Water = chunk.ancestor as? Water else { return nil }
            
            let layer = edge.children.last as? WaterLayer
            
            self.inspectable = (grid: Water, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .layer:
            
            guard let layer = node as? WaterLayer, let edge = layer.ancestor as? WaterEdge, let tile = edge.ancestor as? WaterTile, let chunk = tile.ancestor as? WaterChunk, let Water = chunk.ancestor as? Water else { return nil }
            
            self.inspectable = (grid: Water, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        default: return nil
        }
    }
}


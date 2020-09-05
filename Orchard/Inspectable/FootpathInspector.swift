//
//  FootpathInspector.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct FootpathInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: (grid: Footpath, chunk: FootpathChunk?, tile: FootpathTile?, edge: FootpathEdge?, layer: FootpathLayer?)
    
    init?(node: SceneGraphIdentifiable) {
        
        guard node.category == .footpath else { return nil }
        
        self.node = node
        
        switch node.type {
            
        case .grid:
            
            guard let Footpath = node as? Footpath else { return nil }
            
            self.inspectable = (grid: Footpath, chunk: nil, tile: nil, edge: nil, layer: nil)
            
        case .chunk:
            
            guard let chunk = node as? FootpathChunk, let Footpath = chunk.ancestor as? Footpath else { return nil }
            
            self.inspectable = (grid: Footpath, chunk: chunk, tile: nil, edge: nil, layer: nil)
            
        case .tile:
            
            guard let tile = node as? FootpathTile, let chunk = tile.ancestor as? FootpathChunk, let Footpath = chunk.ancestor as? Footpath else { return nil }
            
            let edge = tile.children.first as? FootpathEdge
            let layer = edge?.children.last as? FootpathLayer
            
            self.inspectable = (grid: Footpath, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .edge:
            
            guard let edge = node as? FootpathEdge, let tile = edge.ancestor as? FootpathTile, let chunk = tile.ancestor as? FootpathChunk, let Footpath = chunk.ancestor as? Footpath else { return nil }
            
            let layer = edge.children.last as? FootpathLayer
            
            self.inspectable = (grid: Footpath, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        case .layer:
            
            guard let layer = node as? FootpathLayer, let edge = layer.ancestor as? FootpathEdge, let tile = edge.ancestor as? FootpathTile, let chunk = tile.ancestor as? FootpathChunk, let Footpath = chunk.ancestor as? Footpath else { return nil }
            
            self.inspectable = (grid: Footpath, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        default: return nil
        }
    }
}



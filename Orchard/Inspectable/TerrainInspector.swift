//
//  TerrainInspector.swift
//  Orchard
//
//  Created by Zack Brown on 28/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct TerrainInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: (grid: Terrain, chunk: TerrainChunk?, tile: TerrainTile<TerrainEdge>?, edge: TerrainEdge?, layer: TerrainLayer?)
    
    init?(node: SceneGraphIdentifiable) {
        
        guard node.category == .terrain else { return nil }
        
        self.node = node
        
        switch node.type {
            
        case .grid:
            
            guard let terrain = node as? Terrain else { return nil }
            
            self.inspectable = (grid: terrain, chunk: nil, tile: nil, edge: nil, layer: nil)
            
        case .chunk:
            
            guard let chunk = node as? TerrainChunk, let terrain = chunk.ancestor as? Terrain else { return nil }
            
            self.inspectable = (grid: terrain, chunk: chunk, tile: nil, edge: nil, layer: nil)
            
        case .tile:
            
            guard let tile = node as? TerrainTile<TerrainEdge>, let chunk = tile.ancestor as? TerrainChunk, let terrain = chunk.ancestor as? Terrain else { return nil }
            
            self.inspectable = (grid: terrain, chunk: chunk, tile: tile, edge: nil, layer: nil)
            
        case .edge:
            
            guard let edge = node as? TerrainEdge, let tile = edge.ancestor as? TerrainTile<TerrainEdge>, let chunk = tile.ancestor as? TerrainChunk, let terrain = chunk.ancestor as? Terrain else { return nil }
            
            self.inspectable = (grid: terrain, chunk: chunk, tile: tile, edge: edge, layer: nil)
            
        case .layer:
            
            guard let layer = node as? TerrainLayer, let edge = layer.ancestor as? TerrainEdge, let tile = edge.ancestor as? TerrainTile<TerrainEdge>, let chunk = tile.ancestor as? TerrainChunk, let terrain = chunk.ancestor as? Terrain else { return nil }
            
            self.inspectable = (grid: terrain, chunk: chunk, tile: tile, edge: edge, layer: layer)
            
        default: return nil
        }
    }
}


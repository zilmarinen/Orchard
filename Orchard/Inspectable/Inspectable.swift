//
//  Inspectable.swift
//  Orchard
//
//  Created by Zack Brown on 04/12/2020.
//

import Meadow

typealias FootpathInspectable = (footpath: Footpath, chunk: FootpathChunk?, tile: FootpathTile?)
typealias TerrainInspectable = (terrain: Terrain, chunk: TerrainChunk?, tile: TerrainTile?)

enum Inspectable {
    
    case camera(Camera)
    case footpath(FootpathInspectable)
    case scene(Scene)
    case terrain(TerrainInspectable)
    
    init?(node: SceneGraphNode) {
        
        switch SceneGraphCategory(rawValue: node.category) {
        
        case .camera:
            
            guard let camera = node as? Camera else { return nil }
            
            self = .camera(camera)
            
        case .footpath:
            
            guard let footpath = node as? Footpath else { return nil }
            
            let chunk = footpath.children.first as? FootpathChunk
            let tile = chunk?.children.first as? FootpathTile
            
            self = .footpath((footpath: footpath, chunk: chunk, tile: tile))
            
        case .footpathChunk:
            
            guard let chunk = node as? FootpathChunk,
                  let footpath = chunk.ancestor as? Footpath else { return nil }
            
            let tile = chunk.children.first as? FootpathTile
            
            self = .footpath((footpath: footpath, chunk: chunk, tile: tile))
            
        case .footpathTile:
            
            guard let tile = node as? FootpathTile,
                  let chunk = tile.ancestor as? FootpathChunk,
                  let footpath = chunk.ancestor as? Footpath else { return nil }
            
            self = .footpath((footpath: footpath, chunk: chunk, tile: tile))
            
        case .scene:
            
            guard let scene = node as? Scene else { return nil }
            
            self = .scene(scene)
            
        case .terrain:
            
            guard let terrain = node as? Terrain else { return nil }
                  
            let chunk = terrain.children.first as? TerrainChunk
            let tile = chunk?.children.first as? TerrainTile
            
            self = .terrain((terrain: terrain, chunk: chunk, tile: tile))
            
        case .terrainChunk:
            
            guard let chunk = node as? TerrainChunk,
                  let terrain = chunk.ancestor as? Terrain else { return nil }
                  
            let tile = chunk.children.first as? TerrainTile
            
            self = .terrain((terrain: terrain, chunk: chunk, tile: tile))
            
        case .terrainTile:
            
            guard let tile = node as? TerrainTile,
                  let chunk = tile.ancestor as? TerrainChunk,
                  let terrain = chunk.ancestor as? Terrain else { return nil }
            
            self = .terrain((terrain: terrain, chunk: chunk, tile: tile))
        
        default: return nil
        }
    }
}

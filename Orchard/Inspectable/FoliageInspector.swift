//
//  FoliageInspector.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct FoliageInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: (grid: Foliage, chunk: FoliageChunk?, tile: FoliageTile?)
    
    init?(node: SceneGraphIdentifiable) {
        
        guard node.category == .foliage else { return nil }
        
        self.node = node
        
        switch node.type {
            
        case .grid:
            
            guard let Foliage = node as? Foliage else { return nil }
            
            self.inspectable = (grid: Foliage, chunk: nil, tile: nil)
            
        case .chunk:
            
            guard let chunk = node as? FoliageChunk, let Foliage = chunk.ancestor as? Foliage else { return nil }
            
            self.inspectable = (grid: Foliage, chunk: chunk, tile: nil)
            
        case .tile:
            
            guard let tile = node as? FoliageTile, let chunk = tile.ancestor as? FoliageChunk, let Foliage = chunk.ancestor as? Foliage else { return nil }
            
            self.inspectable = (grid: Foliage, chunk: chunk, tile: tile)
            
        default: return nil
        }
    }
}



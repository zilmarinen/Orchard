//
//  SceneGraphIdentifiable.swift
//  Orchard
//
//  Created by Zack Brown on 29/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension SceneGraphIdentifiable {
    
    var image: NSImage? {
        
        switch type {
            
        case .grid:
        
            switch category {
                
            case .actors: return NSImage(named: "actors_icon")
            case .area: return NSImage(named: "area_icon")
            case .foliage: return NSImage(named: "foliage_icon")
            case .footpath: return NSImage(named: "footpath_icon")
            case .meadow: return NSImage(named: "meadow_icon")
            case .props: return NSImage(named: "props_icon")
            case .scaffold: return NSImage(named: "scaffold_icon")
            case .terrain: return NSImage(named: "terrain_icon")
            case .tunnel: return NSImage(named: "tunnel_icon")
            case .water: return NSImage(named: "water_icon")
            default: return nil
            }
        
        case .chunk: return NSImage(named: "chunk_icon")
        case .tile: return NSImage(named: "tile_icon")
        case .edge: return NSImage(named: "edge_icon")
        case .layer: return NSImage(named: "layer_icon")
        default: return nil
        }
    }
}

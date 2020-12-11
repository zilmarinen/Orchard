//
//  SceneGraphNode.swift
//  Orchard
//
//  Created by Zack Brown on 10/12/2020.
//

import Cocoa
import Meadow

extension SceneGraphNode {

    public var image: NSImage? {
        
        switch SceneGraphCategory(rawValue: category) {
        
        case .actors: return NSImage(named: "actors_icon")
        case .actor: return NSImage(named: "npc_icon")
        case .area: return NSImage(named: "area_icon")
        case .areaChunk: return NSImage(named: "chunk_icon")
        case .areaTile: return NSImage(named: "tile_icon")
        case .camera: return NSImage(named: "camera_icon")
        case .foliage: return NSImage(named: "foliage_icon")
        case .foliageChunk: return NSImage(named: "chunk_icon")
        case .foliageTile: return NSImage(named: "tile_icon")
        case .footpath: return NSImage(named: "footpath_icon")
        case .footpathChunk: return NSImage(named: "chunk_icon")
        case .footpathTile: return NSImage(named: "tile_icon")
        case .hero: return NSImage(named: "hero_icon")
        case .meadow: return NSImage(named: "meadow_icon")
        case .npcs: return NSImage(named: "actors_icon")
        case .npc: return NSImage(named: "npc_icon")
        case .portals: return NSImage(named: "portal_icon")
        case .portal: return NSImage(named: "portal_icon")
        case .props: return NSImage(named: "prop_icon")
        case .prop: return NSImage(named: "prop_icon")
        case .scene: return NSImage(named: "scene_icon")
        case .terrain: return NSImage(named: "terrain_icon")
        case .terrainChunk: return NSImage(named: "chunk_icon")
        case .terrainTile: return NSImage(named: "tile_icon")
        
        default: return nil
        }
    }
}

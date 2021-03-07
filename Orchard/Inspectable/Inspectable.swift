//
//  Inspectable.swift
//  Orchard
//
//  Created by Zack Brown on 04/12/2020.
//

import Meadow

typealias AreaInspectable = (area: Area, chunk: AreaChunk?, tile: AreaTile?)
typealias BuildingInspectable = (buildings: Buildings, chunk: BuildingChunk?, tile: BuildingTile?, layer: BuildingLayer?)
typealias FoliageInspectable = (foliage: Foliage, chunk: FoliageChunk?, tile: FoliageTile?)
typealias FootpathInspectable = (footpath: Footpath, chunk: FootpathChunk?, tile: FootpathTile?)
typealias PortalsInspectable = (portals: Portals, portal: Portal?)
typealias PropsInspectable = (props: Props, prop: Prop?)
typealias TerrainInspectable = (terrain: Terrain, chunk: TerrainChunk?, tile: TerrainTile?)

enum Inspectable {
    
    case area(AreaInspectable)
    case buildings(BuildingInspectable)
    case camera(Camera)
    case foliage(FoliageInspectable)
    case footpath(FootpathInspectable)
    case portals(PortalsInspectable)
    case props(PropsInspectable)
    case scene(Scene)
    case terrain(TerrainInspectable)
    
    init?(node: SceneGraphNode) {
        
        switch SceneGraphCategory(rawValue: node.category) {
        
        case .area:
            
            guard let area = node as? Area else { return nil }
            
            let chunk = area.children.first as? AreaChunk
            let tile = chunk?.children.first as? AreaTile
            
            self = .area((area: area, chunk: chunk, tile: tile))
            
        case .areaChunk:
            
            guard let chunk = node as? AreaChunk,
                  let area = chunk.ancestor as? Area else { return nil }
            
            let tile = chunk.children.first as? AreaTile
            
            self = .area((area: area, chunk: chunk, tile: tile))
            
        case .areaTile:
            
            guard let tile = node as? AreaTile,
                  let chunk = tile.ancestor as? AreaChunk,
                  let area = chunk.ancestor as? Area else { return nil }
            
            self = .area((area: area, chunk: chunk, tile: tile))
            
        case .buildings:
            
            guard let buildings = node as? Buildings else { return nil }
            
            let chunk = buildings.children.first as? BuildingChunk
            let tile = chunk?.children.first as? BuildingTile
            let layer = tile?.children.first as? BuildingLayer
            
            self = .buildings((buildings: buildings, chunk: chunk, tile: tile, layer: layer))
            
        case .buildingChunk:
            
            guard let chunk = node as? BuildingChunk,
                  let buildings  = chunk.ancestor as? Buildings else { return nil }
            
            let tile = chunk.children.first as? BuildingTile
            let layer = tile?.children.first as? BuildingLayer
            
            self = .buildings((buildings: buildings, chunk: chunk, tile: tile, layer: layer))
            
        case .buildingTile:
            
            guard let tile = node as? BuildingTile,
                  let chunk = tile.ancestor as? BuildingChunk,
                  let buildings = chunk.ancestor as? Buildings else { return nil }
            
            let layer = tile.children.first as? BuildingLayer
            
            self = .buildings((buildings: buildings, chunk: chunk, tile: tile, layer: layer))
            
        case .buildingLayer:
            
            guard let layer = node as? BuildingLayer,
                  let tile = layer.ancestor as? BuildingTile,
                  let chunk = tile.ancestor as? BuildingChunk,
                  let buildings = chunk.ancestor as? Buildings else { return nil }
            
            self = .buildings((buildings: buildings, chunk: chunk, tile: tile, layer: layer))
        
        case .camera:
            
            guard let camera = node as? Camera else { return nil }
            
            self = .camera(camera)
            
        case .foliage:
            
            guard let foliage = node as? Foliage else { return nil }
            
            let chunk = foliage.children.first as? FoliageChunk
            let tile = chunk?.children.first as? FoliageTile
            
            self = .foliage((foliage: foliage, chunk: chunk, tile: tile))
            
        case .foliageChunk:
            
            guard let chunk = node as? FoliageChunk,
                  let foliage = chunk.ancestor as? Foliage else { return nil }
            
            let tile = chunk.children.first as? FoliageTile
            
            self = .foliage((foliage: foliage, chunk: chunk, tile: tile))
            
        case .foliageTile:
            
            guard let tile = node as? FoliageTile,
                  let chunk = tile.ancestor as? FoliageChunk,
                  let foliage = chunk.ancestor as? Foliage else { return nil }
            
            self = .foliage((foliage: foliage, chunk: chunk, tile: tile))
            
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
            
        case .portals:
            
            guard let portals = node as? Portals else { return nil }
            
            let portal = portals.children.first as? Portal
            
            self = .portals((portals: portals, portal: portal))
            
        case .portal:
            
            guard let portal = node as? Portal,
                  let portals = portal.ancestor as? Portals else { return nil }
            
            self = .portals((portals: portals, portal: portal))
            
        case .props:
            
            guard let props = node as? Props else { return nil }
            
            let prop = props.children.first as? Prop
            
            self = .props((props: props, prop: prop))
            
        case .prop:
            
            guard let prop = node as? Prop,
                  let props = prop.ancestor as? Props else { return nil }
            
            self = .props((props: props, prop: prop))
            
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

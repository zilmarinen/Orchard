//
//  InspectorTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension InspectorTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case area(SceneGraphDelegate, Area, AreaChunk?, AreaTile?, AreaNode?)
        case camera(CameraJib)
        case foliage(SceneGraphDelegate, Foliage, FoliageChunk?, FoliageTile?, FoliageNode?)
        case footpath(SceneGraphDelegate, Footpath, FootpathChunk?, FootpathTile?, FootpathNode?)
        case scene(Meadow)
        case terrain(SceneGraphDelegate, Terrain, TerrainChunk?, TerrainTile?, TerrainNode<TerrainLayer>?, TerrainLayer?)
        case water(SceneGraphDelegate, Water, WaterChunk?, WaterTile?, WaterNode?)
        case world(World)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .area: return 1
                
            case .camera: return 2
                
            case .foliage: return 3
                
            case .footpath: return 4
                
            case .scene: return 5
                
            case .terrain: return 6
                
            case .water: return 7
                
            case .world: return 8
            }
        }
    }
    
    class InspectorTabViewModel: BaseViewModel<ViewState> {
        
    }
}

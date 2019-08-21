//
//  InspectorTabstateObserver.swift
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
        case area(editor: Editor, inspectable: AreaInspectable)
        case foliage(editor: Editor, inspectable: FoliageInspectable)
        case footpath(editor: Editor, inspectable: FootpathInspectable)
        case prop(editor: Editor, inspectable: PropInspectable)
        case scene(editor: Editor)
        case terrain(editor: Editor, inspectable: TerrainInspectable)
        case water(editor: Editor, inspectable: WaterInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .area: return 1
                
            case .foliage: return 2
                
            case .footpath: return 3
                
            case .prop: return 4
                
            case .scene: return 5
                
            case .terrain: return 6
                
            case .water: return 7
            }
        }
    }
    
    class InspectorTabStateObserver: BasestateObserver<ViewState> {
        
    }
}

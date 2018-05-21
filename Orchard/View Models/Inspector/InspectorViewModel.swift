//
//  InspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension InspectorTabViewController {
    
    enum ViewState: State {
        
        case empty
        case area
        case camera
        case foliage
        case footpath
        case scene(Meadow)
        case terrain
        case water
        
        func shouldTransition(to newState: InspectorTabViewController.ViewState) -> Should<InspectorTabViewController.ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .area: return 1
                
            case .camera: return 2
                
            case .foliage: return 3
                
            case .footpath: return 4
                
            case .scene(_): return 5
                
            case .terrain: return 6
                
            case .water: return 7
            }
        }
    }
    
    class InspectorViewModel: BaseViewModel<InspectorTabViewController.ViewState> {
        
    }
}

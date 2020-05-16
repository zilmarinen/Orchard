//
//  InspectorTabViewController+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension InspectorTabViewController {
    
    enum ViewState: State {
        
        enum Tab: Int {
            
            case empty
            case actors
            case area
            case foliage
            case footpath
            case meadow
            case props
            case terrain
            case water
        }
        
        case empty
        case actors(SceneGraphIdentifiable)
        case area(SceneGraphIdentifiable)
        case foliage(SceneGraphIdentifiable)
        case footpath(SceneGraphIdentifiable)
        case meadow(SceneGraphIdentifiable)
        case props(SceneGraphIdentifiable)
        case terrain(SceneGraphIdentifiable)
        case water(SceneGraphIdentifiable)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return .empty
            case .actors: return .actors
            case .area: return .area
            case .foliage: return .foliage
            case .footpath: return .footpath
            case .meadow: return .meadow
            case .props: return .props
            case .terrain: return .terrain
            case .water: return .water
            }
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func clear() {
            
            state = .empty
        }
        
        func select(node: SceneGraphNode) {
            
            guard let node = node as? SceneGraphIdentifiable else { return }
            
            switch node.category {
                
            case .actors: self.state = .actors(node)
            case .area: self.state = .area(node)
            case .foliage: self.state = .foliage(node)
            case .footpath: self.state = .footpath(node)
            case .meadow: self.state = .meadow(node)
            case .props: self.state = .props(node)
            case .terrain: self.state = .terrain(node)
            case .water: self.state = .water(node)
                
            default: break
            }
        }
    }
}

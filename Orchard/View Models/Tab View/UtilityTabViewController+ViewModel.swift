//
//  UtilityTabViewController+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension UtilityTabViewController {
    
    enum ViewState: State {
        
        enum Tab: Int {
            
            case empty
            case area
            case foliage
            case footpath
            case props
            case terrain
            case water
        }
        
        case empty
        case area(SceneGraphIdentifiable)
        case foliage(SceneGraphIdentifiable)
        case footpath(SceneGraphIdentifiable)
        case props(SceneGraphIdentifiable)
        case terrain(SceneGraphIdentifiable)
        case water(SceneGraphIdentifiable)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return .empty
            case .area: return .area
            case .foliage: return .foliage
            case .footpath: return .footpath
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
                
            case .area: self.state = .area(node)
            case .foliage: self.state = .foliage(node)
            case .footpath: self.state = .footpath(node)
            case .props: self.state = .props(node)
            case .terrain: self.state = .terrain(node)
            case .water: self.state = .water(node)
                
            default: break
            }
        }
    }
}


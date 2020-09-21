//
//  InspectorTabViewCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension InspectorTabViewCoordinator {
    
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
        case actors(node: SceneGraphIdentifiable)
        case area(node: SceneGraphIdentifiable)
        case foliage(node: SceneGraphIdentifiable)
        case footpath(node: SceneGraphIdentifiable)
        case meadow(node: SceneGraphIdentifiable)
        case props(node: SceneGraphIdentifiable)
        case terrain(node: SceneGraphIdentifiable)
        case water(node: SceneGraphIdentifiable)
        
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
        
        func start(with option: StartOption?) {
            
            guard let node = option as? SceneGraphIdentifiable else { return }
            
            select(node: node)
        }
        
        func stop() {
            
            state = .empty
        }
        
        func select(node: SceneGraphNode) {
            
            guard let node = node as? SceneGraphIdentifiable else { return }
            
            switch node.category {
                
            case .actors: self.state = .actors(node: node)
            case .area: self.state = .area(node: node)
            case .foliage: self.state = .foliage(node: node)
            case .footpath: self.state = .footpath(node: node)
            case .meadow: self.state = .meadow(node: node)
            case .props: self.state = .props(node: node)
            case .terrain: self.state = .terrain(node: node)
            case .water: self.state = .water(node: node)
                
            default: break
            }
        }
    }
}

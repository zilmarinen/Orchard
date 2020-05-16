//
//  SidebarTabViewController+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension SidebarTabViewController {
    
    enum ViewState: State {
        
        @objc enum Tab: Int {
            
            case empty
            case inspector
            case utility
        }
        
        case empty
        case inspector(node: SceneGraphIdentifiable)
        case utility(node: SceneGraphIdentifiable)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return .empty
            case .inspector: return .inspector
            case .utility: return .utility
            }
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func toggle(tab: ViewState.Tab) {
            
            switch tab {
                
            case .empty:
                
                self.state = .empty
                
            case .inspector:
                
                switch state {
                    
                case .utility(let node):
                    
                    self.state = .inspector(node: node)
                    
                default: break
                }
                
            case .utility:
                
                switch state {
                    
                case .inspector(let node):
                    
                    self.state = .utility(node: node)
                
                default: break
                }
            }
        }
        
        func select(node: SceneGraphIdentifiable) {
            
            self.state = .inspector(node: node)
        }
    }
}

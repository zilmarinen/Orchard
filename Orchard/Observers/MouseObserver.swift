//
//  MouseObserver.swift
//  Orchard
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa
import Meadow

extension SceneView {
    
    public enum MouseState: State {
        
        public enum ClickType {
            
            case none
            case left
            case middle
            case right
        }
        
        case down(position: (start: CGPoint, end: CGPoint), type: ClickType)
        case tracking(position: (start: CGPoint, end: CGPoint), type: ClickType)
        case up(position: (start: CGPoint, end: CGPoint), type: ClickType)
        case idle(position: CGPoint)
        case zoom(position: CGPoint, delta: CGFloat)
        
        public func shouldTransition(to newState: MouseState) -> Should<MouseState> {
        
            switch newState {
                
            case .up(let position, _):
                
                return .redirect(.idle(position: position.end))
                
            case .down(let position, let type):
                
                return .redirect(.tracking(position: position, type: type))
                
            case .zoom(let position, _):
                
                return .redirect(.idle(position: position))
                
            default: return .continue
            }
        }
    }
    
    public class MouseObserver: StateObserver<MouseState> {
        
        public var tracksIdleEvents: Bool = false
    }
}

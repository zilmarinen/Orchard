//
//  CursorEvent.swift
//  Base
//
//  Created by Zack Brown on 16/08/2025.
//

import Foundation

public enum CursorEvent {
    
    public enum Button {
        
        case left
        case right
    }
    
    case hover(location: CGPoint)
    case down(location: CGPoint,
              button: Button)
    case drag(start: CGPoint,
              location: CGPoint,
              delta: CGPoint,
              button: Button)
    case up(start: CGPoint,
            location: CGPoint,
            delta: CGPoint,
            button: Button)
}

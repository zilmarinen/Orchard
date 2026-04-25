//
//  MouseButton.swift
//  Base
//
//  Created by Zack Brown on 21/01/2026.
//

public enum MouseButton: Int,
                         CaseIterable,
                         Identifiable {
    
    case left = 1
    case right = 2
    case both = 3
    
    public var id: String {
        
        switch self {
            
        case .left: "Left"
        case .right: "Right"
        case .both: "Both"
        }
    }
}

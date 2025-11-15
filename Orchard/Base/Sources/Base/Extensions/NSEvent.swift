//
//  NSEvent.swift
//
//  Created by Zack Brown on 16/08/2025.
//

import AppKit
import Carbon

extension NSEvent {
    
    public enum KeyCode: Int,
                         Identifiable {
        
        case a = 0
        case d = 2
        case e = 14
        case q = 12
        case r = 15
        case s = 1
        case w = 13
        
        public var id: String {
            
            switch self {
                
            case .a: "A"
            case .d: "D"
            case .e: "E"
            case .q: "Q"
            case .r: "R"
            case .s: "S"
            case .w: "W"
            }
        }
    }
}

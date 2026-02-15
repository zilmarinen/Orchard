//
//  Tool.swift
//
//  Created by Zack Brown on 01/10/2025.
//

import AppKit
import Base
import Foundation

public enum Tool: String,
                  CaseIterable,
                  Identifiable {
    
    case bridges
    case buildings
    case foliage
    case footpaths
    case portals
    case staircases
    case terrain
    case water
    
    public var id: String { rawValue.capitalized }
    
    public var image: NSImage { NSImage(icon: icon)! }
    
    public var color: NSColor {
        
        switch self {
            
        case .bridges: .systemPurple
        case .buildings: .systemOrange
        case .foliage: .systemGreen
        case .footpaths: .systemGray
        case .portals: .systemMint
        case .staircases: .systemCyan
        case .terrain: .systemBrown
        case .water: .systemBlue
        }
    }
    
    private var icon: NSImage.Icon {
        
        switch self {
            
        case .bridges: .bridge
        case .buildings: .building
        case .foliage: .tree
        case .footpaths: .path
        case .portals: .pin
        case .staircases: .stairs
        case .terrain: .mountain
        case .water: .waves
        }
    }
}

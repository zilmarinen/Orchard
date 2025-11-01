//
//  Tool.swift
//
//  Created by Zack Brown on 01/10/2025.
//

public enum Tool: String,
                    CaseIterable,
                    Identifiable {
    
    case bridges
    case buildings
    case foliage
    case footpaths
    case terrain
    case water
    
    public var id: String { rawValue.capitalized }
}

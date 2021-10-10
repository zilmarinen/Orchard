//
//  Tool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

enum Tool: String, Equatable, Identifiable {
    
    static let scene: [Tool] = [.map,
                                .portals,
                                .seams]
    
    static let foliage: [Tool] = [.bushes,
                                  .rocks,
                                  .trees]
    
    static let props: [Tool] = [.bridges,
                                .buildings,
                                .stairs,
                                .walls]
    
    static let surfaces: [Tool] = [.footpaths,
                                   .surface,
                                   .water]
    
    case bridges
    case bushes
    case buildings
    case footpaths
    case map
    case portals
    case rocks
    case seams
    case stairs
    case surface
    case trees
    case walls
    case water
    
    var id: String {  rawValue }
    
    var color: Color {
        
        switch self {
            
        case .bridges: return Color(red: 0.670, green: 0.576, blue: 0.788)
        case .bushes: return Color(red: 1, green: 0.470, blue: 0.470)
        case .buildings: return Color(red: 0.474, green: 0.705, blue: 0.717)
        case .footpaths: return Color(red: 0.458, green: 0.505, blue: 0.517)
        case .map : return Color(red: 0.419, green: 0.478, blue: 0.631)
        case .portals: return Color(red: 0.835, green: 0.494, blue: 0.494)
        case .rocks: return Color(red: 0.588, green: 0.549, blue: 0.513)
        case .seams: return Color(red: 0.8, green: 0.607, blue: 0.427)
        case .stairs: return Color(red: 0.870, green: 0.537, blue: 0.443)
        case .surface: return Color(red: 0.572, green: 0.588, blue: 0.490)
        case .trees: return Color(red: 0.403, green: 0.541, blue: 0.454)
        case .walls: return Color(red: 0.596, green: 0.427, blue: 0.556)
        case .water: return Color(red: 0.192, green: 0.419, blue: 0.513)
        }
    }
    
    var imageName: String {
        
        switch self {
            
        case .bridges: return "directcurrent"
        case .bushes: return "tag"
        case .buildings: return "building.2"
        case .footpaths: return "figure.walk"
        case .map : return "map"
        case .portals: return "arrow.left.and.right.circle"
        case .rocks: return "hexagon"
        case .seams: return "square.fill.and.line.vertical.and.square"
        case .stairs: return "arrow.up.right.and.arrow.down.left.rectangle"
        case .surface: return "waveform.path.ecg"
        case .trees: return "leaf"
        case .walls: return "rectangle"
        case .water: return "drop"
        }
    }
}

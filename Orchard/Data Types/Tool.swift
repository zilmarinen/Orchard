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
            
        case .bridges: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .bushes: return Color(red: 0.0, green: 0.63, blue: 0.61)
        case .buildings: return Color(red: 0.0, green: 0.63, blue: 0.61)
        case .footpaths: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .map : return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .portals: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .rocks: return Color(red: 0.70, green: 0.64, blue: 0.64)
        case .seams: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .stairs: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .surface: return Color(red: 0.23, green: 0.69, blue: 1.0)
        case .trees: return Color(red: 0.43, green: 0.79, blue: 0.38)
        case .walls: return Color(red: 1.0, green: 0.36, blue: 0.34)
        case .water: return Color(red: 1.0, green: 0.36, blue: 0.34)
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

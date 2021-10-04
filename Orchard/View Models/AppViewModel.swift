//
//  AppViewModel.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Foundation
import Harvest
import SwiftUI

class AppViewModel: ObservableObject {
    
    enum Constants {
        
        static let sceneSize = CGSize(width: 128, height: 128)
    }
    
    @Environment(\.openURL) var openURL
    
    @Published var selectedTool: Tool? = .surface
    @Published var myBool: Bool = false
    
    var harvest: Scene2D
    
    init() {
        
        harvest = Scene2D(size: Constants.sceneSize, map: Map2D())
        
        harvest.cursorObserver.subscribe(stateDidChange(from:to:))
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        do {
            
            guard let mapData = fileWrapper.fileWrappers?[Document.Constants.mapFilename]?.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
            
            let map = try JSONDecoder().decode(Map2D.self, from: mapData)
            
            harvest = Scene2D(size: Constants.sceneSize, map: map)
            
            harvest.cursorObserver.subscribe(stateDidChange(from:to:))
        }
        catch {
            
            throw error
        }
    }
    
    func fileWrapper() throws -> FileWrapper {
        
        do {
            
            let data = try JSONEncoder().encode(harvest.map)
            
            var wrappers: [String : FileWrapper] = [:]
            
            wrappers[Document.Constants.mapFilename] = FileWrapper(regularFileWithContents: data)
            
            return .init(directoryWithFileWrappers: wrappers)
        }
        catch {
            
            throw error
        }
    }
}

extension AppViewModel {
    
    func preview() {
        
        guard let url = URL(string: "orchard://com.so.orchard.meadow") else { return }
            
        openURL(url)
    }
}

extension AppViewModel {
    
    func badge(for tool: Tool) -> BadgeModel? {
        
        switch tool {
            
        case .bridges: return .init(title: "\(harvest.map.bridges.chunks.count) | \(harvest.map.bridges.tiles.count)", color: tool.color)
        case .bushes: return .init(title: "\(harvest.map.foliage.chunks.count)", color: tool.color)
        case .buildings: return .init(title: "\(harvest.map.buildings.chunks.count)", color: tool.color)
        case .footpaths: return .init(title: "\(harvest.map.footpath.chunks.count) | \(harvest.map.footpath.tiles.count)", color: tool.color)
        case .portals: return .init(title: "\(harvest.map.portals.chunks.count)", color: tool.color)
        case .rocks: return .init(title: "\(harvest.map.foliage.chunks.count)", color: tool.color)
        case .seams: return .init(title: "\(harvest.map.seams.chunks.count)", color: tool.color)
        case .stairs: return .init(title: "\(harvest.map.stairs.chunks.count)", color: tool.color)
        case .surface: return .init(title: "\(harvest.map.surface.chunks.count) | \(harvest.map.surface.tiles.count)", color: tool.color)
        case .trees: return .init(title: "\(harvest.map.foliage.chunks.count)", color: tool.color)
        case .walls: return .init(title: "\(harvest.map.walls.chunks.count) | \(harvest.map.walls.tiles.count)", color: tool.color)
        case .water: return .init(title: "\(harvest.map.water.chunks.count) | \(harvest.map.water.tiles.count)", color: tool.color)
        default: return nil
        }
    }
}

extension AppViewModel {
    
    func stateDidChange(from: Scene2D.CursorState?, to: Scene2D.CursorState) {
        
        switch to {
            
        case .tracking(let position, _):
            
            print("P: \(position.start) -> \(position.end)")
            
        default: break
        }
    }
}

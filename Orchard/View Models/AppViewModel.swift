//
//  AppViewModel.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Combine
import Foundation
import Harvest
import SwiftUI

class AppViewModel: ObservableObject {
    
    @Environment(\.openURL) var openURL
    
    @ObservedObject var editorModel: EditorViewModel
    @ObservedObject var toolModel = ToolViewModel()
    
    var editorSink: AnyCancellable? = nil
    var toolSink: AnyCancellable? = nil
    
    init() {
        
        editorModel = EditorViewModel(map: Map2D())
        
        startObserving()
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        do {
            
            guard let mapData = fileWrapper.fileWrappers?[Document.Constants.mapFilename]?.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
            
            let map = try JSONDecoder().decode(Map2D.self, from: mapData)
            
            editorModel = EditorViewModel(map: map)
            
            startObserving()
        }
        catch {
            
            throw error
        }
    }
    
    func fileWrapper() throws -> FileWrapper {
        
        do {
            
            let data = try JSONEncoder().encode(editorModel.harvest?.map)
            
            var wrappers: [String : FileWrapper] = [:]
            
            wrappers[Document.Constants.mapFilename] = FileWrapper(regularFileWithContents: data)
            
            return .init(directoryWithFileWrappers: wrappers)
        }
        catch {
            
            throw error
        }
    }
    
    func startObserving() {
        
        editorSink = editorModel.objectWillChange.sink { [weak self] (_) in
            
            self?.objectWillChange.send()
        }
        
        toolSink = toolModel.objectWillChange.sink { [weak self] (_) in
            
            self?.objectWillChange.send()
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
        
        guard let map = editorModel.harvest?.map else { return nil }
        
        switch tool {
            
        case .bridges: return .init(title: "\(map.bridges.chunks.count) | \(map.bridges.tiles.count)", color: tool.color)
        case .bushes: return .init(title: "\(map.foliage.chunks.count)", color: tool.color)
        case .buildings: return .init(title: "\(map.buildings.chunks.count)", color: tool.color)
        case .footpaths: return .init(title: "\(map.footpath.chunks.count) | \(map.footpath.tiles.count)", color: tool.color)
        case .portals: return .init(title: "\(map.portals.chunks.count)", color: tool.color)
        case .rocks: return .init(title: "\(map.foliage.chunks.count)", color: tool.color)
        case .seams: return .init(title: "\(map.seams.chunks.count)", color: tool.color)
        case .stairs: return .init(title: "\(map.stairs.chunks.count)", color: tool.color)
        case .surface: return .init(title: "\(map.surface.chunks.count) | \(map.surface.tiles.count)", color: tool.color)
        case .trees: return .init(title: "\(map.foliage.chunks.count)", color: tool.color)
        case .walls: return .init(title: "\(map.walls.chunks.count) | \(map.walls.tiles.count)", color: tool.color)
        case .water: return .init(title: "\(map.water.chunks.count) | \(map.water.tiles.count)", color: tool.color)
        default: return nil
        }
    }
}

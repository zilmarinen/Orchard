//
//  EditorViewModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Foundation
import Harvest
import Meadow

class EditorViewModel: ObservableObject {
    
    enum Constants {
        
        static let sceneSize = CGSize(width: 96, height: 96)
    }
    
    enum ViewState {
        
        case idle
        case error(error: Error)
        case loading(map: Map2D, progress: Progress)
        case rendering(scene: Scene2D)
    }
    
    lazy var operationQueue: OperationQueue = {
            
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    var harvest: Scene2D? {
        
        switch state {
            
        case .rendering(let scene): return scene
        default: return nil
        }
    }
    
    @Published var state: ViewState = .idle
    
    init(map: Map2D) {
        
        let atlasOperation = TextureAtlasOperation(season: .spring)
        let tilesetOperation = TilesetLoadingOperation()
        
        let progress = atlasOperation.passesResult(to: tilesetOperation).enqueueWithProgress(on: operationQueue) { result in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch result {
                    
                case .failure(let error):
                    
                    self.state = .error(error: error)
                    
                case .success(let output):
                    
                    let (atlas, tileset) = output
                    
                    let scene = Scene2D(size: Constants.sceneSize, map: map, atlas: atlas, tileset: tileset)
                    
                    self.state = .rendering(scene: scene)
                }
            }
        }
        
        state = .loading(map: map, progress: progress)
    }
}

extension EditorViewModel {
    
    func toggle(tool: Tool, isHidden: Bool) {
        
        switch tool {
            
        case .bridges: harvest?.map.bridges.isHidden = isHidden
        case .bushes,
                .rocks,
                .trees: harvest?.map.foliage.isHidden = isHidden
        case .buildings: harvest?.map.buildings.isHidden = isHidden
        case .footpaths: harvest?.map.footpath.isHidden = isHidden
        case .map : harvest?.map.isHidden = isHidden
        case .portals: harvest?.map.portals.isHidden = isHidden
        case .seams: harvest?.map.seams.isHidden = isHidden
        case .stairs: harvest?.map.stairs.isHidden = isHidden
        case .surface: harvest?.map.surface.isHidden = isHidden
        case .walls: harvest?.map.walls.isHidden = isHidden
        case .water: harvest?.map.water.isHidden = isHidden
        }
    }
    
    func grid(isHidden tool: Tool) -> Bool {
        
        switch tool {
            
        case .bridges: return harvest?.map.bridges.isHidden ?? false
        case .bushes,
                .rocks,
                .trees: return harvest?.map.foliage.isHidden ?? false
        case .buildings: return harvest?.map.buildings.isHidden ?? false
        case .footpaths: return harvest?.map.footpath.isHidden ?? false
        case .map : return harvest?.map.isHidden ?? false
        case .portals: return harvest?.map.portals.isHidden ?? false
        case .seams: return harvest?.map.seams.isHidden ?? false
        case .stairs: return harvest?.map.stairs.isHidden ?? false
        case .surface: return harvest?.map.surface.isHidden ?? false
        case .walls: return harvest?.map.walls.isHidden ?? false
        case .water: return harvest?.map.water.isHidden ?? false
        }
    }
}

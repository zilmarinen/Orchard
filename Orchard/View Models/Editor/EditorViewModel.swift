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
        
        static let sceneSize = CGSize(width: 128, height: 128)
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
        
        let progress = atlasOperation.enqueueWithProgress(on: operationQueue) { result in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch result {
                    
                case .failure(let error):
                    
                    self.state = .error(error: error)
                    
                case .success(let atlas):
                    
                    let scene = Scene2D(size: Constants.sceneSize, map: map, atlas: atlas)
                    
                    self.state = .rendering(scene: scene)
                }
            }
        }
        
        state = .loading(map: map, progress: progress)
    }
}

//
//  MeadowViewModel.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class MeadowViewModel: ObservableObject {
    
    enum ViewState {
        
        case idle
        case error(error: Error)
        case loading(map: Map2D, progress: Progress)
        case rendering(scene: MDWScene)
    }
    
    lazy var operationQueue: OperationQueue = {
            
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    @Published var state: ViewState = .idle
    
    func load(map: Map2D) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let atlasOperation = TextureAtlasOperation(season: .spring)
            let previewOperation = MeadowPreviewOperation(map: map)
            
            let progress = atlasOperation.passesResult(to: previewOperation).enqueueWithProgress(on: self.operationQueue) { result in

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }

                    switch result {

                    case .failure(let error):

                        self.state = .error(error: error)

                    case .success(let scene):

                        self.state = .rendering(scene: scene)
                    }
                }
            }
            
            self.state = .loading(map: map, progress: progress)
        }
    }
}

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
        
        print("Loading map: \(map.name ?? "")")
        
        let atlasOperation = TextureAtlasOperation(season: .spring)
        let mapOperation = MapConversionOperation(map: map)
        let propOperation = PropLoadingOperation()
        
        let progress = atlasOperation.passesResult(to: mapOperation).passesResult(to: propOperation).enqueueWithProgress(on: operationQueue) { result in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch result {
                    
                case .failure(let error):
                    
                    self.state = .error(error: error)
                    
                case .success(let output):
                    
                    let (maps, atlas, props) = output
                    
                    guard let map = maps.first else { fatalError("Invalid map") }
                    
                    let scene = MDWScene(map: map, atlas: atlas, props: props)
                    
                    self.state = .rendering(scene: scene)
                }
            }
        }
        
        state = .loading(map: map, progress: progress)
    }
}

//
//  MeadowPreviewOperation.swift
//
//  Created by Zack Brown on 11/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SceneKit

public class MeadowPreviewOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<TextureAtlas, Error> = Result { throw ResultError.noResult }
    public var output: Result<MDWScene, Error> = Result { throw ResultError.noResult }
    
    let map: Map2D
    
    public init(map: Map2D) {
        
        self.map = map
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            guard let device = MTLCreateSystemDefaultDevice() else { return }
            
            let library = try device.makeDefaultLibrary(bundle: Map.bundle)
            
            let atlas = try input.get()
            
            let mapOperation = MapConversionOperation(map: map)
            let propOperation = PropLoadingOperation()
            
            let group = DispatchGroup()
            
            group.enter()
            
            mapOperation.passesResult(to: propOperation).enqueue(on: internalQueue) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                    
                case .failure(let error): self.output = .failure(error)
                case .success(let value):
                    
                    let (map, props) = value
                    
                    let scene = MDWScene(map: map, atlas: atlas, props: props)
                    
                    scene.library = library
                    
                    self.output = .success(scene)
                }
                
                group.leave()
            }
            
            group.wait()
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}


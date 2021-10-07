//
//  MapConversionOperation.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

public class MapConversionOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
 
    public var input: Result<TextureAtlas, Error> = Result { throw ResultError.noResult }
    public var output: Result<([Map], TextureAtlas), Error> = Result { throw ResultError.noResult }
    
    let map: Map2D
    
    public init(map: Map2D) {
        
        self.map = map
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let atlas = try input.get()
            
            let group = DispatchGroup()
            
            let encodingOperation = MapEncodingOperation(map: map)
            let decodingOperation = MapDecodingOperation()
            
            group.enter()
            
            encodingOperation.passesResult(to: decodingOperation).enqueue(on: internalQueue) { result in
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    
                    switch result {
                        
                    case .failure(let error):
                        
                        self.output = .failure(error)
                        
                    case .success(let map):
                        
                        self.output = .success(([map], atlas))
                    }
                    
                    group.leave()
                }
            }
            
            group.wait()
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}



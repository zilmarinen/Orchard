//
//  EdificeInspectorViewModel.swift
//
//  Created by Zack Brown on 23/12/2025.
//

import Deltille
import Lattice

@MainActor
public class EdificeInspectorViewModel {
    
    public private(set) var septomino: Triangle.Septomino = .antlia
    
    public init() {}
}

extension EdificeInspectorViewModel {
    
    internal var septominos: [Triangle.Septomino] {
        
        Triangle.Septomino.allCases
    }
    
    internal var footprint: Triangle.Footprint {
        
        .init(.zero,
              septomino.coordinates)
    }
}

extension EdificeInspectorViewModel {
    
    internal func select(septomino value: Triangle.Septomino) {
        
        septomino = value
    }
    
    internal func septomino(at index: Int) -> Triangle.Septomino {
        
        septominos[index]
    }
}

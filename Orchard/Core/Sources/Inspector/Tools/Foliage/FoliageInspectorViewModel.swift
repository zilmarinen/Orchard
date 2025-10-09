//
//  FoliageInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import Deltille
import Lattice

@MainActor
public class FoliageInspectorViewModel {
    
    public private(set) var septomino: Triangle.Septomino = .antlia
}

extension FoliageInspectorViewModel {
    
    internal var septominos: [Triangle.Septomino] {
        
        Triangle.Septomino.allCases
    }
}

extension FoliageInspectorViewModel {
    
    internal func select(septomino value: Triangle.Septomino) {
        
        septomino = value
    }
    
    internal func septomino(at index: Int) -> Triangle.Septomino {
        
        septominos[index]
    }
}

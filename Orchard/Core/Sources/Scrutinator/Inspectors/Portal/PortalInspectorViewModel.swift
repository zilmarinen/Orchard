//
//  PortalInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 15/02/2026.
//

import Base
import Deltille
import Harvest

@MainActor
internal class PortalInspectorViewModel {
    
    public let triangle: Triangle
    
    internal init(triangle: Triangle) {
     
        self.triangle = triangle
    }
}

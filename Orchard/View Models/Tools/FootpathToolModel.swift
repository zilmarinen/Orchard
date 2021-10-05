//
//  FootpathToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class FootpathToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: FootpathMaterial = .dirt
}

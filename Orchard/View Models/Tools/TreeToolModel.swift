//
//  TreeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class TreeToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var species: TreeSpecies = .spruce
    @Published var direction: Cardinal = .north
}

//
//  StairToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class StairToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: StairMaterial = .stone
    @Published var stairType: StairType = .sloped_1x1
    @Published var direction: Cardinal = .north
}

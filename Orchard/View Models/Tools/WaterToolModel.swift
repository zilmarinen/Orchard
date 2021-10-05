//
//  WaterToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class WaterToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: WaterMaterial = .water
    
    @Published var elevation: Int = 0
}

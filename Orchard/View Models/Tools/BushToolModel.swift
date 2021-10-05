//
//  BushToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class BushToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var species: BushSpecies = .honeysuckle
    @Published var direction: Cardinal = .north
}

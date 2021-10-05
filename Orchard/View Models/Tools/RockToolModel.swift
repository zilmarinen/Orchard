//
//  RockToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class RockToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var rockType: RockType = .causeway
    @Published var direction: Cardinal = .north
}

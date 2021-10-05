//
//  SeamToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class SeamToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var identifier: String = ""
    @Published var segue = Segue()
}

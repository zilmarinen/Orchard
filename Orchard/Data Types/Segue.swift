//
//  Segue.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

class Segue: ObservableObject {
    
    @Published var direction: Cardinal = .north
    @Published var map: String = ""
    @Published var identifier: String = ""
}

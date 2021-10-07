//
//  MapToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class MapToolModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var identifier: String = ""
}

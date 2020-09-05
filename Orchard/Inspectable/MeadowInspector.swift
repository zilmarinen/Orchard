//
//  MeadowInspector.swift
//  Orchard
//
//  Created by Zack Brown on 14/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow

struct MeadowInspector {
    
    let node: SceneGraphIdentifiable
    
    let inspectable: Meadow
    
    init?(node: SceneGraphIdentifiable) {
        
        guard let meadow = node as? Meadow else { return nil }
        
        self.node = node
        
        self.inspectable = meadow
    }
}

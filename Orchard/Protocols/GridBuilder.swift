//
//  GridBuilder.swift
//
//  Created by Zack Brown on 07/10/2021.
//

import Harvest

protocol GridBuilder {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent)
}

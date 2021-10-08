//
//  GridBuilder.swift
//
//  Created by Zack Brown on 07/10/2021.
//

import Harvest
import PeakOperation

protocol GridBuilder {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation?
}

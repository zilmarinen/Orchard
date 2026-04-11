//
//  Debouncer.swift
//  Base
//
//  Created by Zack Brown on 13/02/2026.
//

import Foundation

@MainActor
public class Debouncer {
    
    private static var items: [AnyHashable: DispatchWorkItem] = [:]
    
    public static func perform(context: AnyHashable,
                               after: DispatchTimeInterval,
                               block: @escaping () -> Void) {
        
        let pendingItem = items[context]
        
        pendingItem?.cancel()
        
        let item = DispatchWorkItem(block: block)
        
        items[context] = item
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after,
                                      execute: item)
    }
}

//
//  With.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import Foundation

@discardableResult
public func with<T>(_ value: T,
                    _ builder: (T) -> Void) -> T {
    
    builder(value)
    
    return value
}

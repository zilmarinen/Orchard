//
//  FileWrapper.swift
//
//  Created by Zack Brown on 14/07/2025.
//

import Deltille
import Foundation

extension FileWrapper {
    
    internal enum Key {
        
        case region(vertex: Triangle.Vertex)
        case regions
        case zone(vertex: Triangle.Vertex)
        case zones
        
        case world
        
        internal var path: String {
            
            guard let suffix else { return filename }
            
            return filename + "." + suffix
        }
        
        private var filename: String {
            
            switch self {
                
            case .region(let vertex): vertex.id
            case .regions: "regions"
            case .world: "world"
            case .zone(let vertex): vertex.id
            case .zones: "zones"
            }
        }
        
        private var suffix: String? {
            
            switch self {
                
            case .region,
                 .world,
                 .zone: "json"
                
            default: nil
            }
        }
    }
    
    internal func fileWrapper(forKey key: Key) -> FileWrapper? {
        
        fileWrappers?[key.path]
    }
    
    internal func regularFileContents(forKey key: Key) -> Data? {
        
        fileWrapper(forKey: key)?.regularFileContents
    }
}

extension Dictionary where Key == String,
                           Value == FileWrapper {
    
    internal mutating func write(value: FileWrapper,
                                 forKey key: FileWrapper.Key) {
        
        self[key.path] = value
    }
}

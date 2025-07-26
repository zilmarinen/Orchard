//
//  UTType.swift
//  Base
//
//  Created by Zack Brown on 09/07/2025.
//

import UniformTypeIdentifiers

public extension UTType {
    
    static var documentReadableType: UTType { UTType(importedAs: "com.zrb.orchard.document") }
    static var documentWriteableType: UTType { UTType(exportedAs: "com.zrb.orchard.document") }
}

//
//  Region.swift
//
//  Created by Zack Brown on 21/07/2025.
//

import AppKit
import Deltille
import Foundation
import Harvest

extension Region: @preconcurrency TreeNode {
    
    public var displayName: String { identifier }
    public var image: NSImage? { NSImage(image: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}

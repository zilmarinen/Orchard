//
//  NSAlert.swift
//  Base
//
//  Created by Zack Brown on 05/08/2025.
//

import AppKit

extension NSAlert {
    
    public enum AlertType {
        
        case deleteRegion(identifier: String)
        case deleteZone(identifier: String)
        
        public var message: String {
            
            switch self {
                
            case .deleteRegion(let identifier): "Do you want Delete Region \"\(identifier)\"?"
            case .deleteZone(let identifier): "Do you want Delete Zone \"\(identifier)\"?"
            }
        }
        
        public var information: String {
            
            switch self {
                
            case .deleteRegion,
                 .deleteZone: "This operation cannot be undone."
            }
        }
    }
    
    public convenience init(type: AlertType,
                            style: NSAlert.Style = .warning,
                            buttons: [NSAlert.Button]) {
        
        self.init()
        
        messageText = type.message
        informativeText = type.information
        alertStyle = style
        
        buttons.forEach { addButton(withTitle: $0.id) }
    }
}

extension NSAlert {
    
    public enum Button: String,
                        Identifiable {
        
        case cancel
        case delete
        case deleteRegion = "Delete Region"
        case deleteZone = "Delete Zone"
        
        public var id: String { rawValue.capitalized }
    }
}

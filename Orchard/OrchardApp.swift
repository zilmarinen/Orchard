//
//  OrchardApp.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import SwiftUI

@main
struct OrchardApp: App {
    
    var body: some Scene {
        
        DocumentGroup(newDocument: Document()) { file in
            
            AppView(document: file.$document)
        }
    }
}

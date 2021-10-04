//
//  OrchardApp.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SwiftUI

@main
struct OrchardApp: App {
    
    enum Constants {
        
        static let padding = 8.0
        static let cornerRadius = 8.0
        
        static let edgeInsets = EdgeInsets(top: 2, leading: padding, bottom: 2, trailing: padding)
    }
    
    var body: some Scene {
        
        DocumentGroup(newDocument: Document(model: AppViewModel())) { file in
            
            AppView(document: file.document)
        }
        
        WindowGroup("Meadow Scene Preview") {
        
            MeadowView()
            .frame(minWidth: 350, minHeight: 350)
        }
        .handlesExternalEvents(matching: ["com.so.orchard.meadow"])
    }
}

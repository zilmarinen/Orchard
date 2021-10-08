//
//  OrchardApp.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SwiftUI
import Harvest

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
                .focusedValue(\.document, file.$document)
        }
        .commands {
            
            SidebarCommands()
            
            CommandGroup(after: .saveItem) {
                
                ExportCommand()
            }
        }
        
        WindowGroup("Meadow Scene Preview") {
        
            MeadowView(model: .init())
            .handlesExternalEvents(preferring: ["com.so.orchard.meadow"], allowing: Set(arrayLiteral: "*"))
            .frame(minWidth: 800, minHeight: 600)
        }
        .handlesExternalEvents(matching: ["com.so.orchard.meadow"])
    }
}

struct Container {
    
    static var shared = Container()
    
    var scene: Scene2D? = nil
}

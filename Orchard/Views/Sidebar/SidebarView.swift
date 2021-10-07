//
//  SidebarView.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var appModel: AppViewModel
    
    var body: some View {
        
        List {
            
            SidebarToolGroup(title: "Scene") {
                
                ForEach(Tool.scene, id: \.self) { tool in
                    
                    NavigationLink(destination: ToolView(tool: tool, appModel: appModel), tag: tool, selection: $appModel.toolModel.tool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Foliage") {
                
                ForEach(Tool.foliage, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(tool: tool, appModel: appModel), tag: tool, selection: $appModel.toolModel.tool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Props") {
                
                ForEach(Tool.props, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(tool: tool, appModel: appModel), tag: tool, selection: $appModel.toolModel.tool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Surfaces") {
                
                ForEach(Tool.surfaces, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(tool: tool, appModel: appModel), tag: tool, selection: $appModel.toolModel.tool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool)))
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

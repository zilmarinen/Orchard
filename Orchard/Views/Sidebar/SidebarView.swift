//
//  SidebarView.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        List {
            
            SidebarToolGroup(title: "Scene") {
                
                ForEach(Tool.scene, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(model: model, tool: tool), tag: tool, selection: $model.selectedTool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: model.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Foliage") {
                
                ForEach(Tool.foliage, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(model: model, tool: tool), tag: tool, selection: $model.selectedTool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: model.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Props") {
                
                ForEach(Tool.props, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(model: model, tool: tool), tag: tool, selection: $model.selectedTool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: model.badge(for: tool)))
                    }
                }
            }
            
            SidebarToolGroup(title: "Surfaces") {
                
                ForEach(Tool.surfaces, id: \.self) { tool in
                
                    NavigationLink(destination: ToolView(model: model, tool: tool), tag: tool, selection: $model.selectedTool) {
                
                        SidebarItem(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: model.badge(for: tool)))
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

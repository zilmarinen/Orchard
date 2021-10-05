//
//  MapTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct MapTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: MapToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.mapModel
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool))) {
            
                ToolPropertyView(title: "Name", color: tool.color) {
                
                    TextField("Name", text: $toolModel.name)
                        .onChange(of: toolModel.name) { _ in
                            
                            appModel.editorModel.harvest?.map.name = toolModel.name
                        }
                }
            
                ToolPropertyView(title: "Identifier", color: tool.color) {
                
                    TextField("Identifier", text: $toolModel.identifier)
                        .onChange(of: toolModel.identifier) { _ in
                            
                            appModel.editorModel.harvest?.map.identifier = toolModel.identifier
                        }
                }
            }
        }
    }
}

//
//  FootpathTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct FootpathTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: FootpathToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.footpathModel
        
        toolModel.rendering = !appModel.editorModel.grid(isHidden: tool)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool))) {
                
                ToolPropertyView(title: "Rendering", color: tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            appModel.editorModel.toggle(tool: tool, isHidden: !toolModel.rendering)
                        }
                }
            }
        }
        
        ToolPropertySection {
        
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: tool.color) {
                    
                    Picker("Material", selection: $toolModel.material) {
                        
                        ForEach(FootpathMaterial.allCases, id: \.self) { material in
                        
                            Text(material.id.capitalized).tag(material)
                        }
                    }
                }
            }
        }
    }
}

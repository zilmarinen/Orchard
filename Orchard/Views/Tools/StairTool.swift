//
//  StairTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct StairTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: StairToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.stairModel
        
        toolModel.rendering = !(appModel.editorModel.harvest?.map.stairs.isHidden ?? false)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool))) {
                
                ToolPropertyView(title: "Rendering", color: tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            appModel.editorModel.harvest?.map.stairs.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: tool.color) {
                    
                    Picker("Material", selection: $toolModel.material) {
                        
                        ForEach(StairMaterial.allCases, id: \.self) { material in
                        
                            Text(material.id.capitalized).tag(material)
                        }
                    }
                }
                
                ToolPropertyView(title: "Type", color: tool.color) {
                    
                    Picker("Type", selection: $toolModel.stairType) {
                        
                        ForEach(StairType.allCases, id: \.self) { stairType in
                        
                            Text(stairType.id.capitalized).tag(stairType)
                        }
                    }
                }
                
                ToolPropertyView(title: "Direction", color: tool.color) {
                    
                    Picker("Direction", selection: $toolModel.direction) {
                        
                        ForEach(Cardinal.allCases, id: \.self) { cardinal in
                        
                            Text(cardinal.id.capitalized).tag(cardinal)
                        }
                    }
                }
            }
        }
    }
}

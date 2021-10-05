//
//  SeamTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct SeamTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: SeamToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.seamModel
        
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
            
            ToolPropertyGroup(model: .init(title: "Seam")) {
                
                ToolPropertyView(title: "Identifier", color: tool.color) {
                
                    TextField("Identifier", text: $toolModel.identifier)
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Segue")) {
                
                ToolPropertyView(title: "Map", color: tool.color) {
                
                    TextField("Map", text: $toolModel.segue.map)
                }
                
                ToolPropertyView(title: "Identifier", color: tool.color) {
                
                    TextField("Identifier", text: $toolModel.segue.identifier)
                }
                
                ToolPropertyView(title: "Direction", color: tool.color) {
                    
                    Picker("Direction", selection: $toolModel.segue.direction) {
                        
                        ForEach(Cardinal.allCases, id: \.self) { cardinal in
                        
                            Text(cardinal.id.capitalized).tag(cardinal)
                        }
                    }
                }
            }
        }
    }
}

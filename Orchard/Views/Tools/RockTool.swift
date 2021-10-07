//
//  RockTool.swift
//
//  Created by Zack Brown on 03/10/2021.
//

import Meadow
import SwiftUI

struct RockTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: RockToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.rockModel
        
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
            
            ToolPropertyGroup(model: .init(title: "Foliage")) {
                
                ToolPropertyView(title: "Type", color: tool.color) {
                    
                    Picker("Type", selection: $toolModel.rockType) {
                        
                        ForEach(RockType.allCases, id: \.self) { rockType in
                        
                            Text(rockType.id.capitalized).tag(rockType)
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

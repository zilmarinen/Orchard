//
//  BuildingTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import Meadow
import SwiftUI

struct BuildingTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: BuildingToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.buildingModel
        
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
            
            ToolPropertyGroup(model: .init(title: "Architecture")) {
                
                ToolPropertyView(title: "Architecture", color: tool.color) {
                    
                    Picker("Architecture", selection: $toolModel.architecture) {
                        
                        ForEach(BuildingArchitecture.allCases, id: \.self) { architecture in
                        
                            Text(architecture.id.capitalized).tag(architecture)
                        }
                    }
                }
                
                ToolPropertyView(title: "Polyomino", color: tool.color) {
                    
                    Picker("Polyomino", selection: $toolModel.polyomino) {
                        
                        ForEach(Polyomino.allCases, id: \.self) { polyomino in
                        
                            Text(polyomino.id.capitalized).tag(polyomino)
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

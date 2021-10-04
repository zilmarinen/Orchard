//
//  WallTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct WallTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: WallToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = WallToolModel(tool: tool, rendering: !model.harvest.map.walls.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.walls.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Type", color: toolModel.tool.color) {
                    
                    Picker("Type", selection: $toolModel.wallType) {
                        
                        ForEach(WallType.allCases, id: \.self) { wallType in
                        
                            Text(wallType.id.capitalized).tag(wallType)
                        }
                    }
                }
                
                ToolPropertyView(title: "Material", color: toolModel.tool.color) {
                    
                    Picker("Material", selection: $toolModel.material) {
                        
                        ForEach(WallMaterial.allCases, id: \.self) { material in
                        
                            Text(material.id.capitalized).tag(material)
                        }
                    }
                }
            }
        }
    }
}

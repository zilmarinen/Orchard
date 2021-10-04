//
//  BuildingTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import Meadow
import SwiftUI

struct BuildingTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: BuildingToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = BuildingToolModel(tool: tool, rendering: !model.harvest.map.buildings.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.buildings.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Architecture")) {
                
                ToolPropertyView(title: "Architecture", color: toolModel.tool.color) {
                    
                    Picker("Architecture", selection: $toolModel.architecture) {
                        
                        ForEach(BuildingArchitecture.allCases, id: \.self) { architecture in
                        
                            Text(architecture.id.capitalized).tag(architecture)
                        }
                    }
                }
                
                ToolPropertyView(title: "Polyomino", color: toolModel.tool.color) {
                    
                    Picker("Polyomino", selection: $toolModel.polyomino) {
                        
                        ForEach(Polyomino.allCases, id: \.self) { polyomino in
                        
                            Text(polyomino.id.capitalized).tag(polyomino)
                        }
                    }
                }
                
                ToolPropertyView(title: "Direction", color: toolModel.tool.color) {
                    
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

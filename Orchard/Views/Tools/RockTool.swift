//
//  RockTool.swift
//
//  Created by Zack Brown on 03/10/2021.
//

import Meadow
import SwiftUI

struct RockTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: RockToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = RockToolModel(tool: tool, rendering: !model.harvest.map.foliage.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.foliage.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Foliage")) {
                
                ToolPropertyView(title: "Type", color: toolModel.tool.color) {
                    
                    Picker("Type", selection: $toolModel.rockType) {
                        
                        ForEach(RockType.allCases, id: \.self) { rockType in
                        
                            Text(rockType.id.capitalized).tag(rockType)
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

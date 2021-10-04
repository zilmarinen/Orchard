//
//  WaterTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import SwiftUI
import Meadow

struct WaterTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: WaterToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = WaterToolModel(tool: tool, rendering: !model.harvest.map.water.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.water.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: toolModel.tool.color) {
                    
                    Picker("Material", selection: $toolModel.material) {
                        
                        ForEach(WaterMaterial.allCases, id: \.self) { material in
                        
                            Text(material.id.capitalized).tag(material)
                        }
                    }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Surface")) {
                
                ToolPropertyView(title: "Elevation", color: toolModel.tool.color) {
                    
                    HStack {
                     
                        BadgeView(model: .init(title: "\(toolModel.elevation)", color: toolModel.tool.color))
                        
                        Stepper("Elevation", value: $toolModel.elevation, in: World.Constants.floor...World.Constants.ceiling)
                    }
                }
            }
        }
    }
}

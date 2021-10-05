//
//  WaterTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import SwiftUI
import Meadow

struct WaterTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: WaterToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.waterModel
        
        toolModel.rendering = !(appModel.editorModel.harvest?.map.water.isHidden ?? false)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool))) {
                
                ToolPropertyView(title: "Rendering", color: tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            appModel.editorModel.harvest?.map.water.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: tool.color) {
                    
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
                
                ToolPropertyView(title: "Elevation", color: tool.color) {
                    
                    HStack {
                     
                        BadgeView(model: .init(title: "\(toolModel.elevation)", color: tool.color))
                        
                        Stepper("Elevation", value: $toolModel.elevation, in: World.Constants.floor...World.Constants.ceiling)
                    }
                }
            }
        }
    }
}

//
//  SurfaceTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import Meadow
import SwiftUI

struct SurfaceTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: SurfaceToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = SurfaceToolModel(tool: tool, rendering: !model.harvest.map.surface.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.surface.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
        
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: toolModel.tool.color) {
                    
                    Picker("Material", selection: $toolModel.material) {
                    
                        ForEach(SurfaceMaterial.allCases, id: \.self) { material in
                        
                            Text(material.id.capitalized).tag(material)
                        }
                    }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Overlay")) {
                
                ToolPropertyView(title: "Overlay", color: toolModel.tool.color) {
                    
                    Picker("Overlay", selection: $toolModel.overlay) {
                    
                        Text("None").tag(nil as SurfaceOverlay?)
                        
                        Divider()
                        
                        ForEach(SurfaceOverlay.allCases, id: \.self) { overlay in
                        
                            Text(overlay.id.capitalized).tag(overlay)
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
                
                ToolPropertyView(title: "Surface", color: toolModel.tool.color) {
                    
                    Picker("Surface", selection: $toolModel.tileType) {
                    
                        ForEach(SurfaceTileType.allCases, id: \.self) { tileType in
                        
                            Text(tileType.id.capitalized).tag(tileType)
                        }
                    }
                }
            }
        }
    }
}

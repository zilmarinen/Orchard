//
//  SurfaceTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import Meadow
import SwiftUI

struct SurfaceTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: SurfaceToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.surfaceModel
        
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
        
            ToolPropertyGroup(model: .init(title: "Material")) {
                
                ToolPropertyView(title: "Material", color: tool.color) {
                    
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
                
                ToolPropertyView(title: "Overlay", color: tool.color) {
                    
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
                
                ToolPropertyView(title: "Elevation", color: tool.color) {
                    
                    HStack {
                     
                        BadgeView(model: .init(title: "\(toolModel.elevation)", color: tool.color))
                        
                        Stepper("Elevation", value: $toolModel.elevation, in: World.Constants.floor...World.Constants.ceiling)
                    }
                }
                
                ToolPropertyView(title: "Surface", color: tool.color) {
                    
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

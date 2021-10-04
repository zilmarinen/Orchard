//
//  PortalTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct PortalTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: PortalToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = PortalToolModel(tool: tool, rendering: !model.harvest.map.portals.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.portals.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Portal")) {
                
                ToolPropertyView(title: "Identifier", color: toolModel.tool.color) {
                
                    TextField("Identifier", text: $toolModel.identifier)
                }
                
                ToolPropertyView(title: "Type", color: toolModel.tool.color) {
                    
                    Picker("Type", selection: $toolModel.portalType) {
                        
                        ForEach(PortalType.allCases, id: \.self) { portalType in
                        
                            Text(portalType.id.capitalized).tag(portalType)
                        }
                    }
                }
            }
        }
        
        if toolModel.portalType == .portal {
        
            ToolPropertySection {
            
                ToolPropertyGroup(model: .init(title: "Segue")) {
                    
                    ToolPropertyView(title: "Map", color: toolModel.tool.color) {
                    
                        TextField("Map", text: $toolModel.segue.map)
                    }
                    
                    ToolPropertyView(title: "Identifier", color: toolModel.tool.color) {
                    
                        TextField("Identifier", text: $toolModel.segue.identifier)
                    }
                    
                    ToolPropertyView(title: "Direction", color: toolModel.tool.color) {
                        
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
}

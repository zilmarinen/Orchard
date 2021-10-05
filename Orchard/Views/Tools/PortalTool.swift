//
//  PortalTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct PortalTool: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    @ObservedObject private(set) var toolModel: PortalToolModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
        self.toolModel = appModel.toolModel.portalModel
        
        toolModel.rendering = !(appModel.editorModel.harvest?.map.portals.isHidden ?? false)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: tool.id.capitalized, imageName: tool.imageName, badge: appModel.badge(for: tool))) {
                
                ToolPropertyView(title: "Rendering", color: tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            appModel.editorModel.harvest?.map.portals.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Portal")) {
                
                ToolPropertyView(title: "Identifier", color: tool.color) {
                
                    TextField("Identifier", text: $toolModel.identifier)
                }
                
                ToolPropertyView(title: "Type", color: tool.color) {
                    
                    Picker("Type", selection: $toolModel.portalType) {
                        
                        ForEach(PortalType.allCases, id: \.self) { portalType in
                        
                            Text(portalType.id.capitalized).tag(portalType)
                        }
                    }
                }
            }
        }
        
        if appModel.toolModel.portalModel.portalType == .portal {
        
            ToolPropertySection {
            
                ToolPropertyGroup(model: .init(title: "Segue")) {
                    
                    ToolPropertyView(title: "Map", color: tool.color) {
                    
                        TextField("Map", text: $toolModel.segue.map)
                    }
                    
                    ToolPropertyView(title: "Identifier", color: tool.color) {
                    
                        TextField("Identifier", text: $toolModel.segue.identifier)
                    }
                    
                    ToolPropertyView(title: "Direction", color: tool.color) {
                        
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

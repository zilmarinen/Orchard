//
//  SidebarToolGroup.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct SidebarToolGroup<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        
        Text(title)
            .font(.caption2)
            .foregroundColor(.secondary)
        
        content
    }
}

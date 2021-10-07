//
//  SidebarItem.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import SwiftUI

struct SidebarItem: View {
    
    let model: SidebarItemModel
    
    var body: some View {
        
        HStack {
            
            Label(model.title, systemImage: model.imageName)
            
            Spacer()
            
            if let badge = model.badge {
                
                BadgeView(model: badge)
            }
        }
    }
}

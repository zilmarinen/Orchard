//
//  InspectorTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class InspectorTabViewController: NSTabViewController {

    enum Panel: Int {
        
        case area
        case foliage
        case footpath
        case terrain
        case water
    }
    
    var areaViewController: AreaInspectorViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? AreaInspectorViewController
    }
    
    var foliageViewController: FoliageInspectorViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? FoliageInspectorViewController
    }
    
    var footpathViewController: FootpathInspectorViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? FootpathInspectorViewController
    }
    
    var terrainViewController: TerrainInspectorViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? TerrainInspectorViewController
    }
    
    var waterViewController: WaterInspectorViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? WaterInspectorViewController
    }
}

extension InspectorTabViewController {
    
    func toggle(panel: Panel) {
        
        selectedTabViewItemIndex = panel.rawValue
    }
}

//
//  UtilitiesTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class UtilitiesTabViewController: NSTabViewController {

    enum Panel: Int {
        
        case area
        case foliage
        case footpath
        case terrain
        case water
    }
    
    var areaViewController: AreaUtilitiesViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? AreaUtilitiesViewController
    }
    
    var foliageViewController: FoliageUtilitiesViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? FoliageUtilitiesViewController
    }
    
    var footpathViewController: FootpathUtilitiesViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? FootpathUtilitiesViewController
    }
    
    var terrainViewController: TerrainUtilitiesViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? TerrainUtilitiesViewController
    }
    
    var waterViewController: WaterUtilitiesViewController? {
        
        return childViewControllers[Panel.area.rawValue] as? WaterUtilitiesViewController
    }
}

extension UtilitiesTabViewController {
    
    func toggle(panel: Panel) {
        
        selectedTabViewItemIndex = panel.rawValue
    }
}


//
//  WindowController.swift
//  Orchard
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Deltille
import Region
import Splash
import World

public class WindowController: NSWindowController {
    
    private var regionContainerController: RegionContainerController? { contentViewController as? RegionContainerController }
    private var splashContainerController: SplashContainerController? { contentViewController as? SplashContainerController }
    private var worldContainerController: WorldContainerController? { contentViewController as? WorldContainerController }
    
    private var presentingRegion: Bool { regionContainerController != nil }
    private var presentingSplash: Bool { splashContainerController != nil }
    private var presentingWorld: Bool { worldContainerController != nil }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    public override func windowDidLoad() {
        
        super.windowDidLoad()
        
        showSplash()
    }
    
    private func set(content: NSViewController) {
        
        guard let window else { return }
        
        window.subtitle = content.title ?? ""
        window.toolbarStyle = .unifiedCompact
        
        contentViewController = content
        
        guard let content = content as? HasToolbar else {
            
            window.toolbar = nil
            
            return
        }
        
        window.toolbar = content.toolbar
    }
}

extension WindowController {
    
    private func showRegion(coordinate: Coordinate) {
        
        guard !presentingRegion,
              let document = self.document as? Document else { return }
        
        set(content: RegionContainerController(coordinate: coordinate,
                                               document: document,
                                               delegate: self))
    }
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        set(content: SplashContainerController(delegate: self))
    }
    
    private func showWorld() {
        
        guard !presentingWorld,
              let document = self.document as? Document else { return }
        
        set(content: WorldContainerController(document: document,
                                              delegate: self))
    }
    
    private func showZone(coordinate: Coordinate) {
        
        //
    }
}

extension WindowController: RegionContainerDelegate {
    
    public func regionContainerDidFinish(_ container: RegionContainerController) {
        
        showWorld()
    }
}

extension WindowController: SplashContainerDelegate {
    
    public func splashContainerDidFinish(_ container: SplashContainerController) {
        
        showWorld()
    }
}

extension WindowController: WorldContainerDelegate {
    
    public func worldContainerController(_ container: WorldContainerController,
                                         didRequestEditingFor selection: Document.Selection) {
        
        switch selection {
            
        case .region(let coordinate): showRegion(coordinate: coordinate)
        case .zone(let coordinate): showZone(coordinate: coordinate)
        default: break
        }
    }
}

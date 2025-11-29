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
            window.titleVisibility = .hidden
            
            return
        }
        
        window.toolbar = content.toolbar
        window.titleVisibility = .visible
    }
}

extension WindowController {
    
    private func showRegion(triangle: Triangle) {
        
        guard !presentingRegion,
              let document = self.document as? Document else { return }
        
        set(content: RegionContainerController(triangle: triangle,
                                               document: document,
                                               delegate: self))
    }
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        set(content: SplashContainerController(delegate: self))
    }
    
    private func showWorld(triangle: Triangle? = nil) {
        
        guard !presentingWorld,
              let document = self.document as? Document else { return }
        
        set(content: WorldContainerController(triangle: triangle ?? .zero,
                                              document: document,
                                              delegate: self))
    }
    
    private func showZone(triangle: Triangle) {
        
        //
    }
}

extension WindowController: @preconcurrency RegionContainerDelegate {
    
    public func regionContainer(_ container: RegionContainerController,
                                didFinishEditingRegion triangle: Triangle) {
        
        showWorld(triangle: triangle)
    }
}

extension WindowController: @preconcurrency SplashContainerDelegate {
    
    public func splashContainerDidFinish(_ container: SplashContainerController) {
        
        showWorld()
    }
}

extension WindowController: WorldContainerDelegate {
    
    public func worldContainerController(_ container: WorldContainerController,
                                         didRequestEditingFor selection: Document.Selection) {
        
        switch selection {
            
        case .region(let triangle): showRegion(triangle: triangle)
        case .zone(let triangle): showZone(triangle: triangle)
        default: break
        }
    }
}

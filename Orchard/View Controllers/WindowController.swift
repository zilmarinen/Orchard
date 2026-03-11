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
    
    private var regionContainer: RegionContainer? { contentViewController as? RegionContainer }
    private var splashContainer: SplashContainer? { contentViewController as? SplashContainer }
    private var worldContainer: WorldContainer? { contentViewController as? WorldContainer }
    
    private var presentingRegion: Bool { regionContainer != nil }
    private var presentingSplash: Bool { splashContainer != nil }
    private var presentingWorld: Bool { worldContainer != nil }
    
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
        window.titlebarAppearsTransparent = true
        
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
    
    private func showRegion(vertex: Triangle.Vertex) {
        
        guard !presentingRegion,
              let document = self.document as? Document else { return }
        
        set(content: RegionContainer(vertex: vertex,
                                     document: document,
                                     delegate: self))
    }
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        set(content: SplashContainer(delegate: self))
    }
    
    private func showWorld(focus: Triangle.Vertex? = nil) {
        
        guard !presentingWorld,
              let document = self.document as? Document else { return }
        
        set(content: WorldContainer(vertex: focus ?? .zero,
                                    document: document,
                                    delegate: self))
    }
    
    private func showZone(vertex: Triangle.Vertex) {
        
        //
    }
}

extension WindowController: @preconcurrency RegionContainerDelegate {
    
    public func regionContainer(_ container: RegionContainer,
                                didFinishEditingRegion vertex: Triangle.Vertex) {
        
        showWorld(focus: vertex)
    }
}

extension WindowController: @preconcurrency SplashContainerDelegate {
    
    public func splashContainerDidFinish(_ container: SplashContainer) {
        
        showWorld()
    }
}

extension WindowController: WorldContainerDelegate {
    
    public func worldContainer(_ container: WorldContainer,
                               didRequestEditingFor selection: Document.Selection) {
        
        switch selection {
            
        case .region(let vertex): showRegion(vertex: vertex)
        case .zone(let vertex): showZone(vertex: vertex)
        default: break
        }
    }
}

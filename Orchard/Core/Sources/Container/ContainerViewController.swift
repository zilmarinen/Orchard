//
//  ContainerViewController.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base

open class ContainerViewController: NSViewController {
    
    public var content: NSViewController? {
        
        set { set(content: newValue) }
        get { _content }
    }
    
    private var _content: NSViewController?
    
    public init(content: NSViewController? = nil) {
        
        self._content = content
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.maxXMargin, .maxYMargin]
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.quinarySystemFill.cgColor
        
        guard let content else { return }
            
        swap(from: nil,
             to: content)
    }
        
    public func set(content newContent: NSViewController?) {
        
        if let newContent {
            
            title = newContent.title
            
            let oldContent = content
            
            _content = newContent
            
            guard isViewLoaded else { return }
            
            swap(from: oldContent,
                 to: newContent)
            
        } else if let content {
            
            content.view.removeFromSuperview()
            content.removeFromParent()
            
            _content = nil
        }
    }
    
    private func swap(from oldViewController: NSViewController?,
                      to newViewController: NSViewController) {
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        
        addChild(newViewController)
        
        view.addSubview(newViewController.view)
        
        newViewController.view.pinEdges(to: view)
    }
}

//
//  LayeredContainerViewController.swift
//
//  Created by Zack Brown on 11/08/2025.
//

import AppKit
import Base

open class LayeredContainerViewController: NSViewController {
    
    private var childContainerViews: [ObjectIdentifier: NSView] = [:]
    
    public init() {
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.setContentHuggingPriority(.required,
                                       for: .horizontal)
        view.setContentHuggingPriority(.required,
                                       for: .vertical)
    }
}

extension LayeredContainerViewController {
    
    public func insert(viewController: NSViewController) {
        
        addChild(viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.setContentHuggingPriority(.low,
                                                      for: .horizontal)
        viewController.view.setContentHuggingPriority(.low,
                                                      for: .vertical)
        
        let objectIdentifier = ObjectIdentifier(viewController)
        
        childContainerViews[objectIdentifier] = viewController.view
        
        view.addSubview(viewController.view)
        
        viewController.view.pinEdges(to: view)
    }
    
    func index(of viewController: NSViewController) -> Int? {
        
        let objectIdentifier = ObjectIdentifier(viewController)
        
        guard let containerView = childContainerViews[objectIdentifier] else { return nil }
        
        return view.subviews.firstIndex(of: containerView)
    }
    
    func viewController(at index: Int) -> NSViewController? {
        
        guard view.subviews.indices.contains(index) else { return nil }
        
        let containerView = view.subviews[index]
        
        return children.first { $0.view.superview == containerView }
    }
}

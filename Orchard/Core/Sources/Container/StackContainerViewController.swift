//
//  StackContainerViewController.swift
//  Core
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base

open class StackContainerViewController: NSViewController {
    
    public enum Position {
        
        case start
        case end
        case index(_: Int)
        case after(viewController: NSViewController)
        case before(viewController: NSViewController)
    }
    
    internal lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 0
    }
    
    private var childContainerViews: [ObjectIdentifier: NSView] = [:]
    
    public init(orientation: NSUserInterfaceLayoutOrientation = .vertical) {
        
        super.init(nibName: nil,
                   bundle: nil)
        
        stackView.orientation = orientation
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.pinEdges(to: view)
    }
}

extension StackContainerViewController {
    
    public func insert(viewController: NSViewController,
                       at position: Position = .end,
                       edgeInsets: NSEdgeInsets? = nil) {
        
        let insertionIndex: Int
        
        switch position {
            
        case .start: insertionIndex = 0
        case .end: insertionIndex = children.count
        case .index(let index):
            
            insertionIndex = min(index, children.count)
            
        case .after(let viewController):
            
            if let vcIndex = index(of: viewController) {
                
                insertionIndex = vcIndex + 1
                
            } else {
                
                insertionIndex = children.count
            }
            
        case .before(let viewController):
            
            if let vcIndex = index(of: viewController) {
                
                insertionIndex = vcIndex
                
            } else {
                
                insertionIndex = children.count
            }
        }
        
        insert(viewController: viewController,
               at: insertionIndex,
               edgeInsets: edgeInsets)
    }
    
    public func insert(viewController: NSViewController,
                       at index: Int,
                       edgeInsets: NSEdgeInsets? = nil) {
        
        addChild(viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let objectIdentifier = ObjectIdentifier(viewController)
        
        childContainerViews[objectIdentifier] = viewController.view
        
        stackView.insertArrangedSubview(viewController.view,
                                        at: index)
    }
    
    func index(of viewController: NSViewController) -> Int? {
        
        let objectIdentifier = ObjectIdentifier(viewController)
        
        guard let containerView = childContainerViews[objectIdentifier] else { return nil }
        
        return stackView.arrangedSubviews.firstIndex(of: containerView)
    }
    
    func viewController(at index: Int) -> NSViewController? {
        
        guard stackView.arrangedSubviews.indices.contains(index) else { return nil }
        
        let containerView = stackView.arrangedSubviews[index]
        
        return children.first { $0.view.superview == containerView }
    }
}

open class VerticalStackContainerViewController: StackContainerViewController {
    
    public init() {
        
        super.init(orientation: .vertical)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

open class HorizontalStackContainerViewController: StackContainerViewController {
    
    public init() {
        
        super.init(orientation: .horizontal)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

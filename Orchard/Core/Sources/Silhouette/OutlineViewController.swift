//
//  OutlineViewController.swift
//
//  Created by Zack Brown on 15/07/2025.
//

import AppKit
import Base

public protocol OutlineViewControllerDelegate: AnyObject {
    
    var contents: [any TreeNode] { get }
    
    func outlineViewController(_ controller: OutlineViewController,
                               viewForItem item: any TreeNode) -> NSTableRowView?
    
    func outlineViewController(_ controller: OutlineViewController,
                               didSelect item: any TreeNode,
                               atIndex index: Int)
    
    func outlineViewController(_ controller: OutlineViewController,
                               menuFor item: any TreeNode) -> NSMenu?
}

public class OutlineViewController: NSViewController,
                                    NSOutlineViewDataSource,
                                    NSOutlineViewDelegate {
    
    private enum Constant {
        
        static let headerHeight = 35.0
        static let rowHeight = 21.0
        static let indentation = 8.0
    }
    
    private lazy var scrollView = with(NSScrollView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasVerticalScroller = false
        $0.documentView = outlineView
    }
    
    private lazy var outlineView = with(OutlineView(menuDelegate: self)) {
        
        $0.dataSource = self
        $0.delegate = self
        $0.addTableColumn(column)
        $0.indentationPerLevel = Constant.indentation
        $0.style = .sourceList
        $0.rowSizeStyle = .small
        $0.floatsGroupRows = false
        $0.headerView = nil
        $0.doubleAction = #selector(doubleClicked(_:))
        $0.target = self
    }
    
    private lazy var column = with(NSTableColumn()) {
        
        $0.identifier = NSUserInterfaceItemIdentifier("outline")
        $0.isEditable = false
    }
    
    private weak var delegate: OutlineViewControllerDelegate?
    
    public init(delegate: OutlineViewControllerDelegate) {
        
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.pinEdges(to: view)
    }
}

extension OutlineViewController {
    
    @objc
    private func doubleClicked(_ sender: OutlineView) {
        
        guard let item = sender.item(atRow: sender.clickedRow) as? any TreeNode,
              !item.isLeaf else { return }
        
        if sender.isItemExpanded(item) {
            
            sender.collapseItem(item)
        }
        else {
            
            sender.expandItem(item)
        }
    }
    
    public func reload() {
        
        outlineView.reloadData()
    }
 
    public func select(item: any TreeNode) {
        
        expandParent(for: item)
        
        let index = outlineView.row(forItem: item)
        
        guard index != -1 else { return }
        
        //TODO: Renable this - NSTextField loses focus when editing
//        outlineView.selectRowIndexes([index],
//                                     byExtendingSelection: false)
    }
    
    private func expandParent(for item: any TreeNode) {
        
        var items = [item]
        
        var previous = item
        
        while let parent = delegate?.contents.parent(for: previous) {
            
            items.append(parent)
            
            previous = parent
        }
        
        items.reversed().forEach { outlineView.expandItem($0) }
    }
}

// MARK: NSOutlineViewDataSource

extension OutlineViewController {
    
    public func outlineView(_ outlineView: NSOutlineView,
                            numberOfChildrenOfItem item: Any?) -> Int {
        
        guard let item = item as? any TreeNode else {
            
            guard let contents = delegate?.contents else { fatalError("Invalid content for outline view") }
            
            return contents.count
        }
        
        return item.childCount
    }
    
    public func outlineView(_ outlineView: NSOutlineView,
                            child index: Int,
                            ofItem item: Any?) -> Any {
        
        guard let item = item as? any TreeNode else {
            
            guard let contents = delegate?.contents else { fatalError("Invalid content for outline view") }
            
            return contents[index]
        }
        
        return item.child(at: index)
    }
    
    public func outlineView(_ outlineView: NSOutlineView,
                            isItemExpandable item: Any) -> Bool {
        
        self.outlineView(outlineView,
                         numberOfChildrenOfItem: item) > 0
    }
}

// MARK: NSOutlineViewDelegate

extension OutlineViewController {
    
    public func outlineView(_ outlineView: NSOutlineView,
                            heightOfRowByItem item: Any) -> CGFloat {
        
        guard let item = item as? any TreeNode else { return Constant.rowHeight }
        
        return item.isGroup ? Constant.headerHeight : Constant.rowHeight
    }
    
    public func outlineView(_ outlineView: NSOutlineView,
                            viewFor tableColumn: NSTableColumn?,
                            item: Any) -> NSView? {
        
        guard let item = item as? any TreeNode else { return nil }
        
        let view = delegate?.outlineViewController(self,
                                                   viewForItem: item)
        
        view?.isGroupRowStyle = item.isGroup
        
        return view
    }
    
    public func outlineView(_ outlineView: NSOutlineView,
                            isGroupItem item: Any) -> Bool {
        
        guard let item = item as? any TreeNode else { return false }
        
        return item.isGroup
    }
    
    public func outlineView(_ outlineView: NSOutlineView,
                            shouldSelectItem item: Any) -> Bool {
        
        guard let item = item as? any TreeNode else { return false }
        
        return !item.isGroup
    }
    
    public func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let _ = notification.object as? NSOutlineView,
              let item = outlineView.item(atRow: outlineView.selectedRow) as? any TreeNode else { return }
        
        delegate?.outlineViewController(self,
                                        didSelect: item,
                                        atIndex: outlineView.selectedRow)
    }
}

extension OutlineViewController: @preconcurrency OutlineViewMenuDelegate {
    
    internal func outlineView(_ outlineView: OutlineView,
                              menuFor row: Int) -> NSMenu? {
        
        guard let item = outlineView.item(atRow: row) as? any TreeNode else { return nil }
        
        return delegate?.outlineViewController(self,
                                               menuFor: item)
    }
}

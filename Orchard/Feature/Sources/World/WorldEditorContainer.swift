//
//  WorldEditorContainer.swift
//  Feature
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container

internal protocol WorldEditorDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect region: Bool)
}

internal class WorldEditorContainer: ContainerViewController {
    
    private lazy var loadButton = with(NSButton(title: "Region",
                                                target: self,
                                                action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private weak var delegate: WorldEditorDelegate?
    
    public init(delegate: WorldEditorDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(loadButton)
        
        loadButton.center(in: view)
    }
}

extension WorldEditorContainer {
    
    @objc
    private func button(_ sender: NSButton) {
        
        delegate?.worldEditorContainer(self,
                                       didSelect: true)
    }
}

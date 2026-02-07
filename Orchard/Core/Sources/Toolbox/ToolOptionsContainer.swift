//
//  ToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base
import Design

public protocol ToolOptionsContainerDelegate: AnyObject {}

public class ToolOptionsContainer: NSViewController {
 
    private weak var delegate: ToolOptionsContainerDelegate?
    
    public init(delegate: ToolOptionsContainerDelegate) {
        
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //
    }
}

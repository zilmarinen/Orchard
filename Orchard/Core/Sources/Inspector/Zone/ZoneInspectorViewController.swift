//
//  ZoneInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 28/07/2025.
//

import AppKit
import Base
import Deltille

public protocol ZoneInspectorDelegate: AnyObject {
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didRequestEditingFor selection: Document.Selection)
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didUpdate selection: Document.Selection)
}

public class ZoneInspectorViewController: InspectorViewController {
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneInspectorDelegate?
    
    public init(coordinate: Coordinate,
                document: Document,
                delegate: ZoneInspectorDelegate) {
        
        self.viewModel = .init(coordinate: coordinate,
                               document: document)
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

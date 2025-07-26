//
//  EditorViewController.swift
//  Core
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit

internal class EditorViewController: NSViewController {
    
    private let editor = EditorView()
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editor)
        
        editor.pinEdges(to: view)
    }
}

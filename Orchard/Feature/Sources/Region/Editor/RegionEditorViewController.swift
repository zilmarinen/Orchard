//
//  RegionEditorViewController.swift
//  Feature
//
//  Created by Zack Brown on 12/05/2026.
//

import AppKit
import Base

internal protocol RegionEditorViewDelegate: AnyObject {
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    keyDown keyCode: NSEvent.KeyCode)
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    click button: MouseButton,
                                    location: CGPoint)
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    hover location: CGPoint)
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    magnify magnification: Double)
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    pan button: MouseButton,
                                    location: CGPoint,
                                    translation: CGPoint)
}

internal class RegionEditorViewController: NSViewController {
    
    // MARK: Gesture Recognisers
    
    private lazy var leftClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.left.rawValue
    }
    
    private lazy var rightClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                 action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.right.rawValue
    }
    
    private lazy var panGestureRecognizer = with(NSPanGestureRecognizer(target: self,
                                                                        action: #selector(panGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.both.rawValue
    }
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionEditorViewDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionEditorViewDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(viewModel.editorView)
        
        viewModel.editorView.pinEdges(to: view)
        
        viewModel.editorView.gestureRecognizers = [leftClickGestureRecognizer,
                                                   rightClickGestureRecognizer,
                                                   panGestureRecognizer]
    }
    
    public override func viewDidLayout() {
        
        super.viewDidLayout()
        
        viewModel.editorView.trackingAreas.forEach {
            
            viewModel.editorView.removeTrackingArea($0)
        }
        
        viewModel.editorView.addTrackingArea(.init(rect: viewModel.editorView.frame,
                                                   options: [.activeInKeyWindow,
                                                             .mouseMoved],
                                                   owner: self))
    }
    
    // MARK: Key Down
    
    public override func keyDown(with event: NSEvent) {
        
        guard let keyCode = NSEvent.KeyCode(rawValue: Int(event.keyCode)) else { return }
        
        delegate?.regionEditorViewController(self,
                                             keyDown: keyCode)
    }
    
    // MARK: Mouse Moved

    public override func mouseMoved(with event: NSEvent) {

        super.mouseMoved(with: event)
        
        delegate?.regionEditorViewController(self,
                                             hover: viewModel.location(event.locationInWindow))
    }
    
    // MARK: Scroll

    public override func scrollWheel(with event: NSEvent) {

        super.scrollWheel(with: event)
        
        delegate?.regionEditorViewController(self,
                                             magnify: event.scrollingDeltaY)
    }
}

extension RegionEditorViewController {
    
    // MARK: Click Gesture
    
    @objc
    private func clickGestureRecognizer(_ sender: NSClickGestureRecognizer) {
        
        let button: MouseButton = sender == leftClickGestureRecognizer ? .left : .right
        
        delegate?.regionEditorViewController(self,
                                             click: button,
                                             location: sender.location(in: view))
    }
    
    // MARK: Pan Gesture
    
    @objc
    private func panGestureRecognizer(_ sender: NSPanGestureRecognizer) {
        
        guard let button = MouseButton(rawValue: sender.buttonMask) else { return }
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        let origin = location - translation
        
        delegate?.regionEditorViewController(self,
                                             pan: button,
                                             location: origin,
                                             translation: translation)
    }
}

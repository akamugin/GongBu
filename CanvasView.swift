//
//  CanvasView.swift
//  GongBu
//
//  Created by Stella Lee on 9/30/24.
//

import SwiftUI

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: UIImage?
    
    class Coordinator: NSObject {
        var parent: CanvasView
        var path = UIBezierPath()
        var lastPoint: CGPoint?

        init(parent: CanvasView) {
            self.parent = parent
            self.path.lineWidth = 5
        }

        @objc func panGesture(_ sender: UIPanGestureRecognizer) {
            let currentPoint = sender.location(in: sender.view)

            guard let view = sender.view as? UIImageView else { return }

            if sender.state == .began {
                lastPoint = currentPoint
            } else if sender.state == .changed {
                UIGraphicsBeginImageContext(view.frame.size)
                
                // Draw the current image on the context
                view.image?.draw(in: view.bounds)
                
                // Add lines from the last point to the current point
                let context = UIGraphicsGetCurrentContext()
                context?.move(to: lastPoint ?? currentPoint)
                context?.addLine(to: currentPoint)
                context?.setStrokeColor(UIColor.black.cgColor)
                context?.setLineWidth(5.0)
                context?.setLineCap(.round)
                context?.strokePath()
                
                // Save the new drawing
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                view.image = newImage
                parent.drawing = newImage
                lastPoint = currentPoint
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.panGesture(_:)))
        imageView.addGestureRecognizer(panGesture)
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Set the current drawing if it exists
        uiView.image = drawing
    }
}

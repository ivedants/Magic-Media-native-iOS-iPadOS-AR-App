//
//  ViewController.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/10/20.
//

import UIKit
import SceneKit
import ARKit
import RealityKit

class ViewController: UIViewController, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var coachingOverlay: ARCoachingOverlayView!
//    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        presentCoachingOverlay()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
     //   sceneView.showsStatistics = true
        
                        
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "kettleImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images found")
            

        }

        // Run the view's session
        sceneView.session.run(configuration)
        
       implementCoaching()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        implementCoaching()
    }

    // MARK: - ARSCNViewDelegate
 
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
          //  coachingOverlayViewDidDeactivate(coachingOverlayTemp)
            
            let videoNode = SKVideoNode(fileNamed: "kettle.mp4")
            
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
        }
        
        return node
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if node.isHidden == true {
            if let imageAnchor = anchor as? ARImageAnchor {
                sceneView.session.remove(anchor: imageAnchor)
                }
                }
            }
    
//    public func coachingOverlayViewDidDeactivate(_ coachingOverlayTemp: ARCoachingOverlayView) {
//        coachingOverlayTemp.activatesAutomatically = false
//    }
    
//    func presentCoachingOverlay() {
////        coachingOverlay.session = arView.session
//            coachingOverlay.delegate = self
//            coachingOverlay.goal = .horizontalPlane
//            coachingOverlay.activatesAutomatically = false
//            self.coachingOverlay.setActive(true, animated: true)
//        }

    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.activatesAutomatically = true    }
    
    public func implementCoaching() {
    let coachingOverlayTemp = ARCoachingOverlayView()
    coachingOverlayTemp.session = sceneView.session
   coachingOverlayTemp.delegate = self
    coachingOverlayTemp.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin] //to make sure it resizes if device orientation changes
    coachingOverlayTemp.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(coachingOverlayTemp)
    
 //   Rendering the Coaching Session to the Screen Size
    NSLayoutConstraint.activate([
        coachingOverlayTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        coachingOverlayTemp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        coachingOverlayTemp.widthAnchor.constraint(equalTo: view.widthAnchor),
        coachingOverlayTemp.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    
   coachingOverlayTemp.activatesAutomatically = false
    
    coachingOverlayTemp.setActive(true, animated: true)
    
    coachingOverlayTemp.goal = .anyPlane
        
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            coachingOverlayTemp.activatesAutomatically = true
        }
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {

        // Reset the session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration, options: [.resetTracking])
        implementCoaching()

        // Custom actions to restart the AR experience.
        // ...
    }

    func sessionWasInterrupted(_ session: ARSession) {
        implementCoaching()
    }
}
        

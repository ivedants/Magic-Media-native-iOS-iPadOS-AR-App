//
//  ViewController.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/10/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
 
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
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
        }
        
   

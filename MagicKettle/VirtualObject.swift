//
//  VirtualObject.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/29/20.
//

import Foundation
import SceneKit
import ARKit

extension ViewController {

 
    func addMoon() {
        //Create Geometry of Sphere

        let sphere = SCNSphere(radius: 0.2)
        
        // Creating a material and choosing color
        let material = SCNMaterial()

        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")

        sphere.materials = [material]

        // Defining a node and setting the geometry of the object to be displayed
        let node = SCNNode()

        node.geometry = sphere

        // Putting the node into the SceneView
        
        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
}

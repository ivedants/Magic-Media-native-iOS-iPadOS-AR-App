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
import Speech
import AVFoundation
class ViewController: UIViewController, ARSCNViewDelegate, ARCoachingOverlayViewDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var coachingOverlay: ARCoachingOverlayView!
//    @IBOutlet var arView: ARView!
    
    @IBOutlet weak var recordingButton: UIButton!
    
//    let audioPlayer = AVQueuePlayer()
    
    // MARK: Speech Framework Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    /// Speech variables
//    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    var recognitionTask: SFSpeechRecognitionTask?
//    let audioEngine = AVAudioEngine()
//    let speechRecognizer: SFSpeechRecognizer! =
//        SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    @IBOutlet weak var recognizedText: UITextView!
//    var cancelCalled = false
//    var audioSession = AVAudioSession.sharedInstance()
//    var timer: Timer?
  // let speechService: SpeechService = KeywordsSpeechService()
    
    var audioPlayer : AVPlayer!
    
    var newAudioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        recordingButton.isEnabled = false
//        presentCoachingOverlay()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
     //   sceneView.showsStatistics = true
        
                        
            }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordingButton.isEnabled = true
                    
                case .denied:
                    self.recordingButton.isEnabled = false
                    self.recordingButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordingButton.isEnabled = false
                    self.recordingButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordingButton.isEnabled = false
                    self.recordingButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.recordingButton.isEnabled = false
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
//        if let trackOneDollarFront = ARReferenceImage.referenceImages(inGroupNamed: "oneDollar", bundle: Bundle.main) {
//
//        configuration.trackingImages = trackOneDollarFront
//
//            configuration.maximumNumberOfTrackedImages = 3
//
//            print("One Dollar Bill Front Tracked Successfully!")
//
//        }
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "kettleImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages

            configuration.maximumNumberOfTrackedImages = 10

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
            
          // print(imageAnchor.referenceImage.name)
            
          //  coachingOverlayViewDidDeactivate(coachingOverlayTemp)
            
            if imageAnchor.referenceImage.name == "one-dollar-front" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/george.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        //noteNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.y + 2, z: planeNode.position.z)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                playWashingtonAudio()
            }
            
            
            if imageAnchor.referenceImage.name == "ten-dollar-front" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/hamilton.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        //noteNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.y + 2, z: planeNode.position.z)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                playHamiltonAudio()
            }
            
            
            if imageAnchor.referenceImage.name == "twenty-front" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/jackson.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        //noteNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.y + 2, z: planeNode.position.z)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                playJacksonAudio()
            }
            
            if imageAnchor.referenceImage.name == "listerine" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/listerine.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        //noteNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.y + 2, z: planeNode.position.z)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                // playJacksonAudio()
            }

            if imageAnchor.referenceImage.name == "salmon" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/salmon.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        //noteNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.y + 2, z: planeNode.position.z)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                // playJacksonAudio()
            }

            if imageAnchor.referenceImage.name == "obama-model" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/obama.scn") {

                    if let noteNode = noteScene.rootNode.childNodes.first {
                       
                        
                       // noteNode.position = SCNVector3(x: planeNode.position.x, y: (planeNode.position.y + noteNode.boundingSphere.radius), z: planeNode.position.z)
                        
                        noteNode.eulerAngles.x = .pi/2

                                                
                     //   pokeNode.position = SCNVector3(x: planeNode.position.x, y: planeNode.position.x + pokeNode.boundingSphere.radius, z: planeNode.position.x)
                        
                        planeNode.addChildNode(noteNode)

                    }
                }
                
                // playJacksonAudio()
            }

            
            if imageAnchor.referenceImage.name == "furniture" {

                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

                let planeNode = SCNNode(geometry: plane)

                planeNode.eulerAngles.x = -.pi/2

                node.addChildNode(planeNode)

                if let noteScene = SCNScene(named: "art.scnassets/coffee-table.scn") {
                    
                    if let noteNode = noteScene.rootNode.childNodes.first {
                        
                        noteNode.eulerAngles.x = .pi/2

                        planeNode.addChildNode(noteNode)

                    }
                }
                
                // playJacksonAudio()
            }
            
            
            if imageAnchor.referenceImage.name == "kettle" {
                            
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
            
            if imageAnchor.referenceImage.name == "one-dollar-back" {
                            
            let videoNode = SKVideoNode(fileNamed: "one-dollar.mp4")
            
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
            
            if imageAnchor.referenceImage.name == "ten-dollar-back" {
                            
            let videoNode = SKVideoNode(fileNamed: "ten-dollar.mp4")
            
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
            
            if imageAnchor.referenceImage.name == "twenty-dollar-back" {
                            
            let videoNode = SKVideoNode(fileNamed: "twenty-dollar.mp4")
            
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

            if imageAnchor.referenceImage.name == "costco-auto-program-image" {
                            
            let videoNode = SKVideoNode(fileNamed: "costco-auto-program.mp4")
            
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

            if imageAnchor.referenceImage.name == "costco-mexico" {
                            
            let videoNode = SKVideoNode(fileNamed: "mexico.mp4")
            
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

            if imageAnchor.referenceImage.name == "sensodyne" {
                            
            let videoNode = SKVideoNode(fileNamed: "sensodyne.mp4")
            
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
            
            if imageAnchor.referenceImage.name == "promised-land" {
                            
            let videoNode = SKVideoNode(fileNamed: "promised-land.mp4")
            
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
            
    }
        
        return node
        
    }
    

    
    private func playWashingtonAudio() {
        guard let url = Bundle.main.url(forResource: "washington-quote", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
      
        }
    
    private func playHamiltonAudio() {
        guard let url = Bundle.main.url(forResource: "hamilton-quote", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }
    
    private func playJacksonAudio() {
        guard let url = Bundle.main.url(forResource: "jackson-quote", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }

    private func whatCanYouDo() {
        guard let url = Bundle.main.url(forResource: "whatcanido", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }
    
    private func salmonRecipe() {
        guard let url = Bundle.main.url(forResource: "salmonrecipe", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }
   
    private func oprahInterview() {
        guard let url = Bundle.main.url(forResource: "oprah", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }
    
    private func waterKettle() {
        guard let url = Bundle.main.url(forResource: "waterKettle", withExtension: "mp3") else {
                print("error to get the mp3 file")
                return
            }

            do {
                audioPlayer = try AVPlayer(url: url)
            } catch {
                print("audio file error")
            }
            audioPlayer?.play()
        }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if node.isHidden == true {
            if let imageAnchor = anchor as? ARImageAnchor {
                sceneView.session.remove(anchor: imageAnchor)
                }
                }
            }
    

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
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        implementCoaching()

        // Custom actions to restart the AR experience.
        // ...
    }

    func sessionWasInterrupted(_ session: ARSession) {
        implementCoaching()
    }
    
   // MARK: Speech Implementation
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.recognizedText.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordingButton.isEnabled = true
                self.recordingButton.setTitle("Start Recording", for: [])
            }
            
            
  // MARK: Voice Command Actions
            
            if self.recognizedText.text == "Moon" {
                let sphere = SCNSphere(radius: 0.2)
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
                sphere.materials = [material]
                let node = SCNNode()

                node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
                node.geometry = sphere
                self.sceneView.scene.rootNode.addChildNode(node)

            }
            
            if self.recognizedText.text == "What can you do" {
                self.recognizedText.text = "You can say things like: Any book recommendations, Any good recipes, Instructions for the kettle, I am hungry, and more"
                self.whatCanYouDo()
            }
            
            if (self.recognizedText.text == "I am hungry") || (self.recognizedText.text == "What's for dinner") || (self.recognizedText.text == "Any good recipes")  {
                self.recognizedText.text = "Check out the awesome recipe for salmon in the Costco Connection 2020 file provided with this app"
                self.salmonRecipe()
            }
            
            if (self.recognizedText.text == "Any book recommendations"){
                self.recognizedText.text = "Check out President Obama's interview with Oprah on his new book in the Costco Connection 2020 file provided with this app"
                self.oprahInterview()
            }
            
            if (self.recognizedText.text == "How to use water kettle") || (self.recognizedText.text == "Instructions for the kettle"){
                self.recognizedText.text = "Detect the image on the Water Kettle Instructions Manual file provided with this app for the video"
                self.waterKettle()
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
        recognizedText.text = "(Go ahead, I'm listening) \nSay (What can you do) in order to learn more"
                      
    }
    
   
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordingButton.isEnabled = true
            recordingButton.setTitle("Start Recording", for: [])
        } else {
            recordingButton.isEnabled = false
            recordingButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    
    @IBAction func recordingButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordingButton.isEnabled = false
            recordingButton.setTitle("Stopping", for: .disabled)
            let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(AVAudioSession.Category.playback)
                    try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
                } catch {
                    // handle errors
                }
            recognizedText.text = ""
        } else {
            do {
                try startRecording()
                recordingButton.setTitle("Stop Recording", for: [])
            } catch {
                recordingButton.setTitle("Recording Not Available", for: [])
            }
        }
    
    }
    
    
}
    
    
    


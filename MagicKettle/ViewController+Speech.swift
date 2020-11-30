////
//  ViewController+Speech.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/19/20.
//

import Foundation
import UIKit
import Speech

extension ViewController {

//MARK: permissions

func checkPermissions() {
    var message: String? = nil
    SFSpeechRecognizer.requestAuthorization{(authStatus) in
        switch authStatus {
        case .denied:
            message = "Please enable access to speech recognition."
        case .restricted:
            message = "Speech recognition not available on this device."
        case .notDetermined:
            message = "Speech recognition is still not authorized."
        default: break
         }

        OperationQueue.main.addOperation() {
            self.recordingButton.isEnabled = authStatus == .authorized
            if message != nil {
                self.showAlert(title: "Permissions error", message: message!)
            }
        }
    }
}

    //MARK: - Audio engine and session
    func startAudioSession() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            showAudioError()
        }
    }

    func stopAudioSession() {
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("error stopping audio session")
        }
    }

    func startAudioEngine() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            showAudioError()
        }
    }

    func handleStop() -> Bool {
        if self.cancelCalled == false {
            self.handleRecordingStateChange()
            self.cancelCalled = true
            return true
        }
        
        return false
    }



}

// Recording
extension ViewController {
    func checkExistingRecognitionTask() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    
    func createRecognitionRequest() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
    }
    
    func startRecording() {
        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer
            .recognitionTask(with: recognitionRequest!,
                             resultHandler: {
                                [unowned self] (result, error) in
                                var recognized: String?
                                if result != nil {
                                    recognized = result?.bestTranscription.formattedString
                                    self.timer?.invalidate()
                                    self.timer = nil
                                    if !self.cancelCalled {
                                        self.timer = Timer.scheduledTimer(withTimeInterval: 2,
                                                                          repeats: false,
                                                                          block: { _ in
                                                                            _ = self.handleStop()
                                                                         })
                                    }
                                    self.recognizedText.text = recognized
                                }
                                var finishedRecording = false
                                if result != nil {
                                    finishedRecording = result!.isFinal
                                }
                                if error != nil || finishedRecording {
                                    inputNode.removeTap(onBus: 0)
                                    self.handleFinishedRecording()
                                }
                            })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            [unowned self] (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        startAudioEngine()
    }
    
    @IBAction func startRecording(sender: UIButton) {
        handleRecordingStateChange()
    }
    
    func handleRecordingStateChange() {
        if audioEngine.isRunning {
            executeAction(for: recognizedText.text)
            audioEngine.stop()
            self.stopAudioSession()
            recognitionRequest?.endAudio()
            recordingButton.isEnabled = false
            recordingButton.setTitle("Start Recording", for: .normal)
        } else {
            self.recognizedText.text = ""
            cancelCalled = false
            checkExistingRecognitionTask()
            startAudioSession()
            createRecognitionRequest()
            startRecording()
            recordingButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func handleFinishedRecording() {
        self.audioEngine.stop()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        self.recordingButton.isEnabled = true
    }
}

extension ViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer,
                          availabilityDidChange available: Bool) {
        if available {
            recordingButton.isEnabled = true
        } else {
            recordingButton.isEnabled = false
        }
    }
    
}




// Error handling.
extension ViewController {
    
    func showAudioError() {
        let errorTitle = "Audio Error"
        let errorMessage = "Recording is not possible at the moment."
        self.showAlert(title: errorTitle, message: errorMessage)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Permissions error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// Speech actions
extension ViewController {
    
    func executeAction(for text: String) {
        guard let action = speechService.action(for: text) else {
            return
        }
        
        switch action {
        case .addObject( _):
        addMoon()
//        case .animateAnimal(let animationType):
//            animateAnimal(animationType)
        }
//    }
//
//    private func addObject(_ objectType: ObjectType) {
//    
//    }
//
//    private func animateAnimal(_ animationType: AnimationType) {
//        if let virtualObject = placedAnimal,
//            let animalType = AnimalType(rawValue: virtualObject.modelName),
//            let animationDetails = animalsService.animationDetails(for: animalType,
//                                                                   animationType: animationType) {
//            AnimationManager.startCustomAnimation(for: virtualObject, animationDetails: animationDetails)
//        }
    }
}

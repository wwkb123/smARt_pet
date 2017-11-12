/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit
import SpeechToTextV1
import ToneAnalyzerV3
class ViewController: UIViewController {
    
    
    @IBAction func onBtn1Click(_ sender: UIButton) {
        btn1.isHidden = true
        btn2.isHidden = true
        btn3.isHidden = true
        
        petText.text = "Pet: Sure! How do you feel now?"
        switch emotionToPass{
        case "Sadness":
            break
        case "Joy":
            break
        case "Anger":
            break
        case "Fear":
            break
        case "Disgust":
            break
        default:
            break
        }
    }
    
    @IBAction func onBtn2Click(_ sender: UIButton) {
        petText.text = "Pet: Sure! How do you feel now?"
        btn1.isHidden = true
        btn2.isHidden = true
        btn3.isHidden = true
        
        switch emotionToPass{
        case "Sadness":
            break
        case "Joy":
            break
        case "Anger":
            break
        case "Fear":
            break
        case "Disgust":
            break
        default:
            break
        }
    }
    
    @IBAction func onBtn3Click(_ sender: UIButton) {
        petText.text = "Pet: Sure! How do you feel now?"
        btn1.isHidden = true
        btn2.isHidden = true
        btn3.isHidden = true
        
        switch emotionToPass{
        case "Sadness":
            break
        case "Joy":
            break
        case "Anger":
            break
        case "Fear":
            break
        case "Disgust":
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    
    
    
    
    var emotionToPass = ""
    
    
    
    //Waston Speech to Text
    var speechToText: SpeechToText!

    var speechToTextSession: SpeechToTextSession!
    
    var toneAnalyzer: ToneAnalyzer!
  //  var toneAnalyzer: ToneAnalyzer!
    var isStreaming = false
    var isMenuClick = false
    var askClickCount = 0
    @IBAction func onAskClick(_ sender: UIButton) {
        askClickCount+=1
        switch askClickCount {
        case 1:
            self.petText.text = "Pet: Try not to take F train today as it has been doing bad from 11/10 - 11/11."
            break
        case 2:
            self.petText.text = "Pet: According to your calendar, you will have a Calculus exam on 11/13. Please be reminded to study."
            break
        case 3:
            self.petText.text = "Pet: Buy me a big hamburger as you have promised me before."
            askClickCount = 0
            break
        default:
            break
        }
        
    }
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var gameBtn: UIButton!
    @IBOutlet weak var askBtn: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var petText: UILabel!
    var recText = ""
    @IBAction func onMenuClick(_ sender: UIButton) {
        if(isMenuClick){
            menuBtn.setImage(#imageLiteral(resourceName: "icons8-xbox_menu_filled"), for: .normal)
            isMenuClick = !isMenuClick
        }else{
            menuBtn.setImage(#imageLiteral(resourceName: "icons8-xbox_menu_filled-1"), for: .normal)
            isMenuClick = !isMenuClick
        }
        gameBtn.isHidden = !gameBtn.isHidden
        feedBtn.isHidden = !feedBtn.isHidden
        askBtn.isHidden = !askBtn.isHidden
    }
    
    var desCount = 0;
    
    
    // MARK: - ARKit Config Properties
    var screenCenter: CGPoint?

    let session = ARSession()
    let standardConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    // MARK: - Virtual Object Manipulation Properties
    
    var dragOnInfinitePlanesEnabled = false
    var virtualObjectManager: VirtualObjectManager!
    
    var isLoadingObject: Bool = false {
        didSet {
            DispatchQueue.main.async {
                //self.settingsButton.isEnabled = !self.isLoadingObject
                self.addObjectButton.isEnabled = !self.isLoadingObject
                self.restartExperienceButton.isEnabled = !self.isLoadingObject
               
            }
        }
    }
    
    // MARK: - Other Properties
    
    var textManager: TextManager!
    var restartExperienceButtonIsEnabled = true
    
    // MARK: - UI Elements
    
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var restartExperienceButton: UIButton!
    
  
    
    // MARK: - Queues
    
	let serialQueue = DispatchQueue(label: "com.apple.arkitexample.serialSceneKitQueue")
	
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        speechToTextSession = SpeechToTextSession(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        
        toneAnalyzer = ToneAnalyzer(username: Credentials.ToneAnalyzerUsername, password: Credentials.ToneAnalyzerPassword, version: "2016-05-19")
        
        
        
        Setting.registerDefaults()
		setupUIControls()
        setupScene()
        
        
    }
    

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed after a while.
		UIApplication.shared.isIdleTimerDisabled = true
		
		if ARWorldTrackingConfiguration.isSupported {
			// Start the ARSession.
			resetTracking()
		} else {
			// This device does not support 6DOF world tracking.
			let sessionErrorMsg = "This app requires world tracking. World tracking is only available on iOS devices with A9 processor or newer. " +
			"Please quit the application."
			displayErrorMessage(title: "Unsupported platform", message: sessionErrorMsg, allowRestart: false)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		session.pause()
	}
	
    // MARK: - Setup
    
	func setupScene() {
        // Synchronize updates via the `serialQueue`.
        virtualObjectManager = VirtualObjectManager(updateQueue: serialQueue)
        virtualObjectManager.delegate = self
		
		// set up scene view
		sceneView.setup()
		sceneView.delegate = self
		sceneView.session = session
		// sceneView.showsStatistics = true
		
		sceneView.scene.enableEnvironmentMapWithIntensity(25, queue: serialQueue)
		
		setupFocusSquare()
		
		DispatchQueue.main.async {
			self.screenCenter = self.sceneView.bounds.mid
		}
	}
    
    func setupUIControls() {
        textManager = TextManager(viewController: self)
        
        // Set appearance of message output panel
        messagePanel.layer.cornerRadius = 3.0
        messagePanel.clipsToBounds = true
        messagePanel.isHidden = true
        messageLabel.text = ""
    }
	
    // MARK: - Gesture Recognizers
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesBegan(touches, with: event, in: self.sceneView)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesMoved(touches, with: event)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if virtualObjectManager.virtualObjects.isEmpty {
			chooseObject(addObjectButton)
			return
		}
		virtualObjectManager.reactToTouchesEnded(touches, with: event)
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesCancelled(touches, with: event)
	}
	
    // MARK: - Planes
	
	var planes = [ARPlaneAnchor: Plane]()
	
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        
		let plane = Plane(anchor)
		planes[anchor] = plane
		node.addChildNode(plane)
		
		textManager.cancelScheduledMessage(forType: .planeEstimation)
		textManager.showMessage("SURFACE DETECTED")
		if virtualObjectManager.virtualObjects.isEmpty {
			textManager.scheduleMessage("TAP + TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .contentPlacement)
		}
	}
		
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
			plane.update(anchor)
		}
	}
			
    func removePlane(anchor: ARPlaneAnchor) {
		if let plane = planes.removeValue(forKey: anchor) {
			plane.removeFromParentNode()
        }
    }
	
	func resetTracking() {
		session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
		
		textManager.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT",
		                            inSeconds: 7.5,
		                            messageType: .planeEstimation)
	}

    // MARK: - Focus Square
    
    var focusSquare: FocusSquare?
	
    func setupFocusSquare() {
		serialQueue.async {
			self.focusSquare?.isHidden = true
			self.focusSquare?.removeFromParentNode()
			self.focusSquare = FocusSquare()
			self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
		}
		
		textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }
	
	func updateFocusSquare() {
		guard let screenCenter = screenCenter else { return }
		
		DispatchQueue.main.async {
			var objectVisible = false
			for object in self.virtualObjectManager.virtualObjects {
				if self.sceneView.isNode(object, insideFrustumOf: self.sceneView.pointOfView!) {
					objectVisible = true
					break
				}
			}
			
			if objectVisible {
				self.focusSquare?.hide()
                
			} else {
				self.focusSquare?.unhide()
			}
			
            let (worldPos, planeAnchor, _) = self.virtualObjectManager.worldPositionFromScreenPosition(screenCenter,
                                                                                                       in: self.sceneView,
                                                                                                       objectPos: self.focusSquare?.simdPosition)
			if let worldPos = worldPos {
				self.serialQueue.async {
					self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
				}
				self.textManager.cancelScheduledMessage(forType: .focusSquare)
			}
		}
	}
    
	// MARK: - Error handling
	
	func displayErrorMessage(title: String, message: String, allowRestart: Bool = false) {
		// Blur the background.
		textManager.blurBackground()
		
		if allowRestart {
			// Present an alert informing about the error that has occurred.
			let restartAction = UIAlertAction(title: "Reset", style: .default) { _ in
				self.textManager.unblurBackground()
				self.restartExperience(self)
			}
			textManager.showAlert(title: title, message: message, actions: [restartAction])
		} else {
			textManager.showAlert(title: title, message: message, actions: [])
		}
	}
    
    
    @IBAction func onMicroClick(_ sender: UIButton) {
        streamMicrophoneBasic()
    }
    /**
     This function demonstrates how to use the basic
     `SpeechToText` class to transcribe microphone audio.
     */
    public func streamMicrophoneBasic() {
        if !isStreaming {
            
            // update state
            // microphoneButton.setTitle("Stop Microphone", for: .normal)
            microphoneButton.setImage(#imageLiteral(resourceName: "icons8-record_filled-1"), for: .normal)
            isStreaming = true
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.interimResults = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                //  self.textView.text = results.bestTranscript
                self.recText = results.bestTranscript
                
                print(self.recText)
            }
            
        } else {
            
            // update state
            // microphoneButton.setTitle("Start Microphone", for: .normal)
            microphoneButton.setImage(#imageLiteral(resourceName: "icons8-record_filled-2"), for: .normal)
            isStreaming = false
            let failure = { (error: Error) in print(error) }
            var text = recText
            var max = 0.0
            var maxEmotion = ""
            var output = ""
                            toneAnalyzer.getTone(ofText: text, failure: failure) { tones in
                                for emotionTone in tones.documentTone[0].tones {
                                    if(emotionTone.score >= 0.3){
                                        output = emotionTone.name + ": "+String(emotionTone.score*100)+"%"+"\n"
                                        print(output)
                                        if(emotionTone.score > max){
                                            max = emotionTone.score
                                            maxEmotion = String(emotionTone.name)
                                            print(maxEmotion)
                                            // print(emotionTone.id)
                                        }
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.petText.text = output+"Pet: "+maxEmotion+" is with you today!"+"("+String(max*100)+"%"+")"+"\nHere are some suggestions:"
                                    self.petText.sizeToFit()
                                    
                                    self.btn1.isHidden = false
                                    self.btn2.isHidden = false
                                    self.btn3.isHidden = false
                                    
                                   
                                    switch maxEmotion{
                                    case "Sadness":
                                        self.btn1.setTitle("Play some songs", for: .normal)
                                        self.btn2.setTitle("Tell a joke", for: .normal)
                                        self.btn3.setTitle("Ask online specialists for help", for: .normal)
                                        self.emotionToPass = "Sadness"
                                        break
                                    case "Joy":
                                        self.btn1.setTitle("Dance with me", for: .normal)
                                        self.btn2.setTitle("Post a selfie to Facebook", for: .normal)
                                        self.btn3.setTitle("Send a message to your family", for: .normal)
                                        self.emotionToPass = "Joy"
                                        break
                                    case "Anger":
                                        self.btn1.setTitle("Yell", for: .normal)
                                        self.btn2.setTitle("Go work out with me", for: .normal)
                                        self.btn3.setTitle("Make a call to Jack", for: .normal)
                                        self.emotionToPass = "Anger"
                                        break
                                    case "Fear":
                                        self.btn1.setTitle("Play some relax songs", for: .normal)
                                        self.btn2.setTitle("Call 911", for: .normal)
                                        self.btn3.setTitle("Ask online specialists for help", for: .normal)
                                        self.emotionToPass = "Fear"
                                        break
                                    case "Disgust":
                                        self.btn1.setTitle("Play some songs", for: .normal)
                                        self.btn2.setTitle("Tell a joke", for: .normal)
                                        self.btn3.setTitle("Make a call to Martin", for: .normal)
                                        self.emotionToPass = "Disgust"
                                        break
                                    default:
                                        self.emotionToPass = ""
                                        break
                                    }
                                    
                                    
                                }
                                
                            }
            
        
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
           
            
            //                    let scene = SCNScene(named:"Models.scnassets/bear/bear.scn")
            //                    let bear = scene?.rootNode.childNode(withName: "bear", recursively: true)
            //                    bear?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)), forKey: "bear_rotate")
            //                    self.sceneView.scene = scene!
        }
        
    }
    
    /**
     This function demonstrates how to use the more advanced
     `SpeechToTextSession` class to transcribe microphone audio.
     */
    public func streamMicrophoneAdvanced() {
        if !isStreaming {
            
            // update state
            //            microphoneButton.setTitle("Stop Microphone", for: .normal)
            
            isStreaming = true
            
            // define callbacks
            speechToTextSession.onConnect = { print("connected") }
            speechToTextSession.onDisconnect = { print("disconnected") }
            speechToTextSession.onError = { error in print(error) }
            speechToTextSession.onPowerData = { decibels in print(decibels) }
            speechToTextSession.onMicrophoneData = { data in print("received data") }
            speechToTextSession.onResults = { results in
                
                // self.textView.text = results.bestTranscript
                //  print(results.bestTranscript)
            }
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.interimResults = true
            
            // start recognizing microphone audio
            speechToTextSession.connect()
            speechToTextSession.startRequest(settings: settings)
            speechToTextSession.startMicrophone()
            
        } else {
            
            // update state
            //            microphoneButton.setTitle("Start Microphone", for: .normal)
            
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToTextSession.stopMicrophone()
            speechToTextSession.stopRequest()
            speechToTextSession.disconnect()
        }
    }
}

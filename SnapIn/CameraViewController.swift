//
//  CameraViewController.swift
//  SnapIn
//
//  Created by Adam Debono on 29/11/2015.
//  Copyright © 2015 SnapIn Technologies. All rights reserved.
//

import AudioToolbox
import UIKit
import ZXingObjC

class CameraViewController: UIViewController, ZXCaptureDelegate {
	
	private var viewVisible = false
	private var captureLoaded = false
	
	private var capture : ZXCapture!
	
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return .Portrait
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupCapture()
    }
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.viewVisible = true
		self.startCapture()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.viewVisible = false
		self.stopCapture()
	}
	
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.capture.layer.frame = self.view.bounds
	}
	
	
	deinit {
		self.stopCapture()
		self.capture.layer.removeFromSuperlayer()
	}
	
	//MARK: -
	
	//MARK: Capture
	
	func setupCapture() {
		//show loading indicator
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			self.capture = ZXCapture()
			self.capture.rotation = 90
			dispatch_sync(dispatch_get_main_queue()) {
				self.capture.camera = self.capture.back()
			}
			self.capture.delegate = self
			
			
			dispatch_async(dispatch_get_main_queue()) {
				self.view.layer.insertSublayer(self.capture.layer, atIndex: 0)
				
				self.captureLoaded = true
				//hide loading indicator
			}
		}
	}
	
	func startCapture() {
		if (self.viewVisible && self.captureLoaded) {
			self.capture.start()
		}
	}
	
	func stopCapture() {
		self.capture.stop()
	}
	
	func captureResult(capture: ZXCapture!, result: ZXResult!) {
		guard let _ = result else {
			return
		}
		
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
		
		self.capture.stop()
	}
}

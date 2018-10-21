//
//  PopupViewController.swift
//  smartdarkmode
//
//  Created by Michael Zhou on 2018-10-21.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Cocoa
import CoreLocation

class PopupViewController: NSViewController, CLLocationManagerDelegate {
    
    private var isEnabled: Bool = false
    var locMgr = CLLocationManager()
    
    @IBOutlet weak var toggleButton: NSButton!
    @IBOutlet weak var autoChecked: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locMgr.delegate = self
        locMgr.startUpdatingLocation()
        isEnabled = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        print(isEnabled)
        if (isEnabled) {
            toggleButton.title = "light mode"
        } else {
            toggleButton.title = "dark mode"
        }
    }
    
    @IBAction func toggleClicked(_ sender: Any) {
        if isEnabled {
            disable()
            print("Dark mode disabled")
            isEnabled = false
            toggleButton.title = "dark mode"
        } else {
            enable()
            print("Dark mode enabled")
            isEnabled = true
            toggleButton.title = "light mode"
        }
    }
    
    @IBAction func autoClicked(_ sender: Any) {
        if (autoChecked.state == .off) {
            toggleButton.isEnabled = true
        } else {
            toggleButton.isEnabled = false
        }
    }
    
    
    func enable() {
        runAppleScript("tell application \"System Events\" to tell appearance preferences to set dark mode to true")
    }
    
    func disable() {
        runAppleScript("tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode")
    }
    
    @discardableResult
    func runAppleScript(_ source: String) -> String? {
        return NSAppleScript(source: source)?.executeAndReturnError(nil).stringValue
    }
    
    func getLocation() -> [CLLocationDegrees] {
        return [(locMgr.location?.coordinate.latitude)!, (locMgr.location?.coordinate.longitude)!]
    }
}

extension PopupViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> PopupViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopupViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopupViewController else {
            fatalError("Why cant i find PopupViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

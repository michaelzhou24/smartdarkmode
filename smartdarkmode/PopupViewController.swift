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
    var sunsetSunRiseTimes : [Date] = []
    var sunset : Date = Date(timeIntervalSinceReferenceDate: 0)
    var sunrise : Date = Date(timeIntervalSinceReferenceDate: 0)
    @IBOutlet weak var toggleButton: NSButton!
    @IBOutlet weak var autoChecked: NSButton!
    var timerSunset = Timer()
    var timerSunrise = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locMgr.delegate = self
        locMgr.startUpdatingLocation()
        isEnabled = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        if (isEnabled) {
            toggleButton.title = "light mode"
        } else {
            toggleButton.title = "dark mode"
        }
        //let sunTimer = Timer(timeInterval: 3600*24*7, target: self, selector: #selector(getNewSunData), userInfo: nil, repeats: true)
        //RunLoop.main.add(sunTimer, forMode: .common)
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
        if (autoChecked.state == .on) {
            toggleButton.isEnabled = true
            let coord = locMgr.location?.coordinate
            sunsetSunRiseTimes = getSunriseSunset(lat: (coord?.latitude)!, lon: (coord?.longitude)!)
            
            while sunsetSunRiseTimes.count == 0 {
                print("Failed to get sunrise & sunset times.")
                return
            }
            sunrise = sunsetSunRiseTimes[0].convertToLocalTime()
            sunset = sunsetSunRiseTimes[1].convertToLocalTime()
            timerSunrise = Timer(fireAt: sunrise, interval: 3600*24, target: self, selector: #selector(disable), userInfo: nil, repeats: true)
            timerSunset = Timer(fireAt: sunrise, interval: 3600*24, target: self, selector: #selector(enable), userInfo: nil, repeats: true)
            RunLoop.main.add(timerSunset, forMode: .common)
            RunLoop.main.add(timerSunrise, forMode: .common)
            print("Auto enabled")
        } else {
            toggleButton.isEnabled = false
            timerSunrise.invalidate()
            timerSunset.invalidate()
            print("Auto disabled")
        }
    }
    
    
    @objc
    func enable() {
        runAppleScript("tell application \"System Events\" to tell appearance preferences to set dark mode to true")
    }
    
    @objc
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
    
    @IBAction func quitClicked(_ sender: Any) {
        exit(0);
    }
    
}

extension PopupViewController {
    static func freshController() -> PopupViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopupViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopupViewController else {
            fatalError("Why cant i find PopupViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

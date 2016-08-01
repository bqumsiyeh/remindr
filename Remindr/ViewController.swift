//
//  ViewController.swift
//  Remindr
//
//  Created by Basel Qumsiyeh on 8/1/16.
//  Copyright © 2016 Basel Qumsiyeh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    weak var mainTimer: NSTimer?
    weak var secondTimer: NSTimer?
    var secondsLeft = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet var actionTF: NSTextField!
    @IBOutlet var hoursTF: NSTextField!
    @IBOutlet var minutesTF: NSTextField!

    @IBOutlet var startStopBtn: NSButton!
    @IBOutlet var timerLabel: NSTextField!
    
    
    @IBAction func exitClicked(sender: NSButton) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func btnClicked(sender: NSButton) {
        
        if (mainTimer == nil) {
            
            toggleButton(true)
            
            calculateSeconds()
            updateLabel(self.secondsLeft)
            
            createAndStartTimers()
        }
        else {
            toggleButton(false)
            self.secondsLeft = 0
            secondTimer?.invalidate()
            mainTimer?.invalidate()
            updateLabel(0)
        }
    }
    
    func calculateSeconds() {
        let hours = self.hoursTF.integerValue;
        let minutes = self.minutesTF.integerValue;
        let seconds = (hours * 3600) + (minutes * 60)
        self.secondsLeft = seconds;
    }
    
    func toggleButton(x: Bool) {
        self.startStopBtn.title = x ? "Stop" : "Start"
    }
    
    func createAndStartTimers () {
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(Double(self.secondsLeft), target: self, selector: "mainTimerDone", userInfo: nil, repeats: false)
        secondTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "secondTimerDone:", userInfo: nil, repeats: true)
    }
    
    func updateLabel(seconds: Int) {
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds)
        
        var str = ""
        
        if (h > 0) {
            str += String(h) + "h, "
        }
        
        str += String(m) + "m, "
        str += String(s) + "s";
        
        self.timerLabel.stringValue = str;
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func mainTimerDone() {
        
        secondTimer?.invalidate()
        
        showNotification()
        
        calculateSeconds()
        updateLabel(self.secondsLeft)
        
        createAndStartTimers()
    }
    
    func secondTimerDone(timer:NSTimer) {
        
        self.secondsLeft--
        updateLabel(self.secondsLeft)
        
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification.init()
        notification.title = "Reminder";
        notification.informativeText = self.actionTF.stringValue
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
}


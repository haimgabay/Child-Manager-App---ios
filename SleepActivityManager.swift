//
//  SleepActivityManager.swift
//  ChildManagerApp
//
//  Created by Haim Gabay on 06/12/2016.
//  Copyright © 2016 Haim Gabay. All rights reserved.
//

import UIKit

class SleepActivityManager: UIViewController{
 
    var buttonStartAndPause: UIButton!;
    var buttonStop: UIButton!;
    var timer: Timer!;
    var counter = 0;
    var labelTime: UILabel!;
    @IBOutlet weak var elapsedTimeLabel: UILabel!;
    var manualAddingView: UIView!;
    var alertSleepTime: UIAlertController!;
    var childName: String?;
    var lastActivitiesLabel: UILabel!;
    var labelActivitiesArray = [UILabel]();
    var labelToArray: UILabel!;
    var lastActivitiesView: UIView!;
    var imageOfChild: UIImage!;
    var imageContainer: UIImageView!
    var userChildList: UserChildsList!;
        //STOP WATCH VARIABLES:
    var stopWatchLabel: UILabel!;
    var startTime = TimeInterval();
    var stopWatchTimer: Timer!;
    var elapsed: TimeInterval = 0;
    var totalSleepingTime = 0;
    
    var dateToSend: NSDate!;
    var timePicker: UIDatePicker!;
    var timePicker2: UIDatePicker!;
    var hours,minutes,seconds: String?;
    
    override func viewDidLoad() {
        if childName != nil{
        print(childName!);
        }
        view.backgroundColor = UIColor.white;
        //BACK BUTTON:
        let buttonGoBack = UIButton(type: .system);
        buttonGoBack.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        buttonGoBack.addTarget(self, action: #selector(self.goToPreviousViewController(_:)), for: .touchUpInside);
        view.addSubview(buttonGoBack);
        let imageForBackButtun = UIImage(named: "back-button");
        let imageView = UIImageView(image: imageForBackButtun);
        imageView.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        view.addSubview(imageView);
        // HEADLINE LABEL:
        let labelHeadline = UILabel(frame: CGRect(x: view.frame.width/2 - 140, y: 30, width: 280, height: 35));
        labelHeadline.text = "Sleeping Follow-up";
        labelHeadline.textAlignment = .center;
        labelHeadline.textColor = UIColor.blue;
        labelHeadline.font = labelHeadline.font.withSize(30);
        view.addSubview(labelHeadline);
        // GET CURRENT DATE:
        let currentDate = NSDate();
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short;
        let convertedDate = dateFormatter.string(from: currentDate as Date);
        // DISPLAY DATE LABEL:
        let labelDate = UILabel(frame: CGRect(x: view.frame.width/2 - 70, y: 80, width: 140, height: 40));
        labelDate.textColor = UIColor.purple;
        labelDate.text = convertedDate;
        labelDate.textAlignment = .center;
        labelDate.font = labelDate.font.withSize(15);
        view.addSubview(labelDate);
        // CURRENT CHILD IMAGE:
        imageContainer = UIImageView(image: imageOfChild);
        imageContainer.frame = CGRect(x: labelDate.frame.maxX + 30, y: labelDate.frame.minY, width: 70, height: 90);
        view.addSubview(imageContainer);
        // GET CURRENT TIME:
        let currentTime = NSDate();
        let timeFormatter = DateFormatter();
        timeFormatter.timeStyle = .short;
        let convertedTime = timeFormatter.string(from: currentTime as Date);
        // DISPLAY TIME LABEL:
        labelTime = UILabel(frame: CGRect(x: view.frame.width/2 - 70, y: labelDate.frame.maxY + 5, width: 140, height: 40));
        labelTime.textColor = UIColor.purple;
        labelTime.text = convertedTime;
        labelTime.textAlignment = .center;
        labelTime.font = labelTime.font.withSize(28);
        view.addSubview(labelTime);
        // START & PAUSE BUTTON:
        buttonStartAndPause = UIButton(type: .system);
        buttonStartAndPause.setTitle("START", for: .normal);
        buttonStartAndPause.frame =  CGRect(x: view.frame.width/2 + 85, y: labelTime.frame.maxY + 10, width: 100, height: 45);
        buttonStartAndPause.backgroundColor = UIColor.green;
        buttonStartAndPause.addTarget(self, action: #selector(self.startOrPause(_:)), for: .touchUpInside);
        view.addSubview(buttonStartAndPause);
        // STOP BUTTON:
        buttonStop = UIButton(type: .system);
        buttonStop.setTitle("STOP", for: .normal);
        buttonStop.frame =  CGRect(x: view.frame.width/2 - 185, y: labelTime.frame.maxY + 10, width: 100, height: 45);
        buttonStop.backgroundColor = UIColor.red;
        buttonStop.addTarget(self, action: #selector(self.stop(_:)), for: .touchUpInside);
        view.addSubview(buttonStop);
        // MANUAL ADDING BUTTON:
        let buttonManualAdding = UIButton(type: .system);
        buttonManualAdding.frame = CGRect(x: 0, y: labelDate.frame.minY, width: 100, height: 45);
        buttonManualAdding.setTitle("ADD +", for: .normal);
        buttonManualAdding.addTarget(self, action: #selector(self.showAddingView(_:)), for: .touchUpInside);
        view.addSubview(buttonManualAdding);
        // HANDLE TIMER:
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleTimer(_:)), userInfo: nil, repeats: true);
        // TIMER LABEL:
        stopWatchLabel = UILabel(frame: CGRect(x: view.frame.width/2 - 60, y: buttonStartAndPause.frame.midY - 10, width: 120, height: 40));
        stopWatchLabel.font = stopWatchLabel.font.withSize(28);
        stopWatchLabel.text = "00:00:00";
        view.addSubview(stopWatchLabel);
        
        // MANUAL UPDATE VIEW:
        manualAddingView = UIView(frame: CGRect(x: 0, y: buttonStartAndPause.frame.maxY + 15, width: view.frame.width, height: view.frame.height - view.frame.midY + 100));
        // TIME PICKER'S & LABEL'S:
        let labelTimePicker1 = UILabel(frame: CGRect(x: manualAddingView.frame.width / 2 - 45, y: 5, width: 90, height: 15));
        labelTimePicker1.text = "start time:"
        labelTimePicker1.textColor = UIColor.orange
        manualAddingView.addSubview(labelTimePicker1);
        timePicker = UIDatePicker(frame: CGRect(x: 0, y: labelTimePicker1.frame.maxY + 5, width: manualAddingView.frame.width, height: 150));
        timePicker.datePickerMode = .dateAndTime;
        manualAddingView.addSubview(timePicker);
        let labelTimePicker2 = UILabel(frame: CGRect(x: manualAddingView.frame.width / 2 - 40, y: timePicker.frame.maxY + 5, width: 80, height: 15));
        labelTimePicker2.text = "end time:"
        labelTimePicker2.textColor = UIColor.orange
        manualAddingView.addSubview(labelTimePicker2);
        timePicker2 = UIDatePicker(frame: CGRect(x: 0, y: labelTimePicker2.frame.maxY + 5, width: view.frame.width, height: 150));
        timePicker2.datePickerMode = .dateAndTime;
        manualAddingView.addSubview(timePicker2);
        let buttonConfirmPick: UIButton = UIButton(type: .system);
        buttonConfirmPick.frame = CGRect(x: manualAddingView.frame.width / 2 - 30, y: timePicker2.frame.maxY + 20, width: 60, height: 45);
        buttonConfirmPick.backgroundColor = UIColor.cyan;
        buttonConfirmPick.setTitle("OK", for: .normal);
        buttonConfirmPick.addTarget(self, action: #selector(self.pickConfirm), for: .touchUpInside);
        manualAddingView.addSubview(buttonConfirmPick);
        //LAST ACTIVITIES VIEW:
        lastActivitiesView = UIView(frame: CGRect(x: 0, y: stopWatchLabel.frame.maxY + 5, width: view.frame.width, height: view.frame.height - stopWatchLabel.frame.maxY - 5));
        //LAST ACTIVITIES LABEL:
        lastActivitiesLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 150, y: 0, width: 300, height: 60));
        lastActivitiesLabel.numberOfLines = 2;
        lastActivitiesLabel.text = childName! + "'s last sleep activities:\ndate             total";
        lastActivitiesLabel.textAlignment = .center;
        lastActivitiesView.addSubview(lastActivitiesLabel);
}
    func showAddingView(_ sender: UIButton){
        lastActivitiesView.removeFromSuperview();
        view.addSubview(manualAddingView);
    }
    
    func handleTimer(_ sender: Timer){
        let currentTime = NSDate();
        let timeFormatter = DateFormatter();
        timeFormatter.timeStyle = .short;
        let convertedTime = timeFormatter.string(from: currentTime as Date);
        labelTime.text = convertedTime;
    }
    
    @IBAction func startOrPause(_ sender: UIButton){
        if self.buttonStartAndPause.titleLabel!.text == "START"{
            self.buttonStartAndPause.setTitle("PAUSE", for: .normal);
            buttonStartAndPause.backgroundColor = UIColor.yellow;
            let aSelector : Selector = #selector(SleepActivityManager.updateTime);
            stopWatchTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true);
            startTime = NSDate.timeIntervalSinceReferenceDate - elapsed;
        }else{
            self.buttonStartAndPause.setTitle("START", for: .normal);
            buttonStartAndPause.backgroundColor = UIColor.green;
            pause(sender);
            
            
        }
    }
    @IBAction func pause(_ sender: AnyObject) {
        stopWatchTimer.invalidate();
    }
    
    @IBAction func stop(_ sender: UIButton){
        buttonStartAndPause.setTitle("START", for: .normal);
        buttonStartAndPause.backgroundColor = UIColor.green;
        if stopWatchTimer != nil{
            if stopWatchLabel.text == "00:00:00"{
            }else{
            stopWatchTimer.invalidate();
            dateToSend = NSDate();
            let hours = UInt8(elapsed / 3600.0);
            elapsed -= (TimeInterval(hours) * 3600);
            let minutes = UInt8(elapsed / 60.0);
            elapsed -= (TimeInterval(minutes) * 60);
            let seconds = UInt8(elapsed);
            elapsed -= TimeInterval(seconds);
            totalSleepingTime = Int(elapsed);
            self.hours = String(hours);
            self.minutes = String(minutes);
            self.seconds = String(seconds);
            alertControllerGenerator();
            elapsed = 0;
            stopWatchLabel.text = "00:00:00";
         }
       }
    }
    
    func pickConfirm(_ sender: UIButton){
        
        if #available(iOS 10.0, *) {
            if (timePicker2.date < timePicker.date){
                self.hours = "ERROR";
                self.minutes = "E";
                self.seconds = "E";
                alertControllerGenerator();
            }else{
            dateToSend = timePicker.date as NSDate;
            var elapsedTime: TimeInterval = DateInterval(start: timePicker.date, end: timePicker2.date).duration;
            print("the interval is: \(elapsedTime)");
            //calculate the hours in elapsed time.
            let hours = UInt8(elapsedTime / 3600.0);
            elapsedTime -= (TimeInterval(hours) * 3600);
            //calculate the minutes in elapsed time.
            let minutes = UInt8(elapsedTime / 60.0);
            elapsedTime -= (TimeInterval(minutes) * 60);
            //calculate the seconds in elapsed time.
            let seconds = UInt8(elapsedTime);
            elapsedTime -= TimeInterval(seconds);
            let strHours = String(format: "%02d", hours);
            let strMinutes = String(format: "%02d", minutes);
            let strSeconds = String(format: "%02d", seconds);
                self.hours = strHours;
                self.minutes = strMinutes;
                self.seconds = strSeconds;
            alertControllerGenerator();
            }
        }else {
            // Fallback on earlier versions
        }
        }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate;
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime;
        elapsed = elapsedTime;
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0);
        elapsedTime -= (TimeInterval(hours) * 3600);
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0);
        elapsedTime -= (TimeInterval(minutes) * 60);
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime);
        elapsedTime -= TimeInterval(seconds);
        let strHours = String(format: "%02d", hours);
        let strMinutes = String(format: "%02d", minutes);
        let strSeconds = String(format: "%02d", seconds);
        stopWatchLabel.text = "\(strHours):\(strMinutes):\(strSeconds)";
}
    
    func alertControllerGenerator(){
        if alertSleepTime == nil{
            alertSleepTime = UIAlertController(title: "SLEEP TIME:", message: "\(self.hours!):\(self.minutes!):\(self.seconds!)\n" + "HH/MM/SS", preferredStyle: .alert);
            let actionCancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (UIAlertAction) in
                print("cancel pushed");
            });
            let actionSave = UIAlertAction(title: "SAVE", style: .default, handler: { (UIAlertAction) in
                self.view.addSubview(self.lastActivitiesView);
                self.labelActivitiesArray.append(self.generateLabelFromString());
                self.lastActivitiesView.addSubview(self.labelActivitiesArray[self.labelActivitiesArray.count - 1]);
                self.manualAddingView.removeFromSuperview();
            });
                alertSleepTime.addAction(actionCancel);
                alertSleepTime.addAction(actionSave);
        }else{
            if !alertSleepTime.actions[1].isEnabled{
                alertSleepTime.actions[1].isEnabled = true;
            }
            alertSleepTime.title = "SLEEP TIME:";
             alertSleepTime.message = "\(self.hours!):\(self.minutes!):\(self.seconds!)\n" + "HH/MM/SS";
        }
        if self.hours! == "ERROR"{
            alertSleepTime.title = "ERROR";
            alertSleepTime.message = "end time point's on earlier time then start time - please choose again";
            alertSleepTime.actions[1].isEnabled = false;
        }
        present(alertSleepTime, animated: true, completion: nil);

    }
    func generateLabelFromString() -> UILabel{
        if labelActivitiesArray.count == 0{
            labelToArray = UILabel(frame: CGRect(x: view.frame.width / 2 - 150, y: lastActivitiesLabel.frame.maxY + 10, width: 300, height: 30));
        }else{
            labelToArray = UILabel(frame: CGRect(x: view.frame.width / 2 - 150, y: labelActivitiesArray[labelActivitiesArray.count - 1].frame.maxY + 10, width: 300, height: 30));
        }
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .short;
        let convertedDate = dateFormatter.string(from: dateToSend as Date);
            labelToArray.textAlignment = .center;
        labelToArray.text = "\(convertedDate) --> \(hours!):\(minutes!):\(seconds!)";
        return labelToArray;
    }
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    func goToPreviousViewController(_ sender: UIButton){
        userChildList.sleepActivityController = nil;
         dismiss(animated: true, completion: nil);
    }
}

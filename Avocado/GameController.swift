//
//  GameController.swift
//  Kiwi
//
//  Created by Lucio Busà on 16/03/21.
//

import Cocoa
import AVFoundation

class GameController: NSViewController {
    
    @IBOutlet var currentView: NSView!
    var player: AVAudioPlayer?
    var degree: Int!;
    var showLeft: Int!;
    var showRight: Int!;
    var changeDegree: Int = 0;
    var number: Int!;
    var block: Int! = 0;
    let limit: Int! = 8;
    var phase: Int! = 0;
    var toAppend: String! = " per iniziare"
    var dct: [String] = ["B","C","D","F","G","H","L","M","N","P","Q","R","S","T","V","Z"].shuffled()
    var answers: [String:[String]] = ["CorretteDestra":[],"ErrateDestra":[],"CorretteSinistra":[],"ErrateSinistra":[]]
    var monitor: Any?
    var optionsDictionary: [NSView.FullScreenModeOptionKey:Any]!
    
    @IBOutlet weak var message: NSTextField!
    @IBOutlet weak var lecterRight: NSTextField!
    @IBOutlet weak var lecterLeft: NSTextField!
    @IBOutlet weak var cross: NSImageView!
    
    override func viewWillDisappear() {
        NSApplication.shared.terminate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        begin();
    }

    
    func begin(){
        self.message.stringValue = "premi la barra spaziatrice" + self.toAppend
        self.message.isHidden = false;
        self.lecterLeft.isHidden = true;
        self.lecterRight.isHidden = true;
        self.cross.isHidden = true;
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
                   self.keyDown(with: $0)
                   return nil
               }
    }
    
    func startGame(){
        self.toAppend = "";
        self.showLeft = 0;
        self.showRight = 0;
        initGame();
    }
    
    
    override func viewDidAppear() {
        if(degree == 1){
            self.changeDegree = 200
        }
        view.window?.toggleFullScreen(self)
        NSCursor.hide()
        self.lecterRight.frame.origin.x = CGFloat(cross.frame.origin.x + 200 + CGFloat(self.changeDegree))
        self.lecterLeft.frame.origin.x = CGFloat(cross.frame.origin.x - 200 - CGFloat(self.changeDegree))
    }
    
    func initGame(){
        self.phase = 2;
        self.message.isHidden = true;
        self.cross.isHidden = false;
        self.lecterRight.isHidden = true;
        self.lecterLeft.isHidden = true;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if(self.showLeft < self.limit || self.showRight < self.limit){
            NSSound(named: "suono")?.play()
            let seconds = Double.random(in: 1.5..<2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.changeLecter()
            }
            }
            else {self.checkEnd()}
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        self.begin()
        }
    }
    
    func changeLecter(){
        self.number = Int.random(in: 0..<2)
        if( self.showLeft<self.limit) && (number == 0 || self.showRight == self.limit){
            self.number = 0;
            if(self.block == 0){ self.lecterLeft.stringValue = dct[self.showLeft]}
            else {self.lecterLeft.stringValue = dct[8+self.showLeft]}
            self.lecterLeft.isHidden = false
            showLeft += 1
        }
        else if(self.showRight<self.limit){
            self.number = 1;
            if(self.block == 0){ self.lecterRight.stringValue = dct[8+self.showRight]}
            else {self.lecterRight.stringValue = dct[self.showRight]}
            self.lecterRight.isHidden = false
            showRight += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            self.lecterLeft.isHidden = true;
            self.lecterRight.isHidden = true;
        }
    }
    
    func letterMiddle(){
        self.message.isHidden = false;
        self.cross.isHidden = true;
        if(self.number==0){
            self.message.stringValue = self.lecterLeft.stringValue
        }
        else{
            self.message.stringValue = self.lecterRight.stringValue
        }
        self.message.stringValue += " \n\n(S:corretta; N:errata)"
        self.phase = 3
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
                   self.keyDown(with: $0)
                   return nil
               }
    }
    
    func checkEnd(){
        if(self.block < 1){
            self.phase = 0
            self.toAppend = " per la seconda fase"
            self.block += 1;
        }
        else {
            createCSV(from: answers)
             NSEvent.removeMonitor(self.monitor!)
            NSApplication.shared.terminate(self)
        }
    }
    
    func saveLecterRight(){
        if(self.number == 0){
            answers["CorretteSinistra"]?.append(self.lecterLeft.stringValue)
        }
        else {
            answers["CorretteDestra"]?.append(self.lecterRight.stringValue)
        }
        initGame()
    }
    
    func saveLecterWrong(){
        if(self.number == 0){
            answers["ErrateSinistra"]?.append(self.lecterLeft.stringValue)
        }
        else {
            answers["ErrateDestra"]?.append(self.lecterRight.stringValue)
        }
       initGame()
    }
    
    func createCSV(from recArray:[String:[String]]) {
        var csvString = ""
        for item in recArray {
                csvString = csvString.appending("\(String(item.key));\(String( recArray[item.key]!.count));")
            if(recArray[item.key]!.count>0){
                for value in item.value {
                    csvString = csvString.appending("\(String(describing:value));")
                }
                csvString = csvString.appending("\n")
            }
            }

            let fileManager = FileManager.default
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
                dateFormatter.timeZone = NSTimeZone(name: "GMT+2") as TimeZone?
                let date = dateFormatter.string(from: NSDate() as Date)
                let path = try fileManager.url(for: .desktopDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                var fileURL = path.appendingPathComponent("Avocado")
                do
                {
                    try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
                    fileURL = fileURL.appendingPathComponent("Avocado"+date+".csv")
                    
                }
                catch let error as NSError
                {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }

        }
    
    
    override func keyDown(with event: NSEvent) // A key is pressed
    {
        //controlla se la space bar è stata premuta
        switch event.keyCode {
        case 49:
            switch self.phase {
            case 0:
                NSEvent.removeMonitor(self.monitor!)
                print("her3")
                self.startGame()
            case 1:
                NSEvent.removeMonitor(self.monitor!)
                self.initGame()
            case 2:
                NSEvent.removeMonitor(self.monitor!)
                self.letterMiddle()
            default:
                print("no")
            }
        case 53:
            //self.presentingViewController?.dismiss(self)
            NSApplication.shared.terminate(self)
        case 1:
            if(self.phase==3){
                NSEvent.removeMonitor(self.monitor!)
                self.saveLecterRight()
            }
        case 45:
            if(self.phase==3){
                NSEvent.removeMonitor(self.monitor!)
                self.saveLecterWrong()
            }
        default:
            print(event.keyCode)
    }
    }
}
    
    
   
       
       
   
       
       

 

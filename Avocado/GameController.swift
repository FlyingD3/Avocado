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
    var dct: [String] = ["B","C","D","F","G","H","L","M","N","P","Q","R","S","T","V","Z"].shuffled()
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
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
                   self.keyDown(with: $0)
                   return nil
               }
        begin();
    }

    
    func begin(){
        self.message.stringValue = "premi la barra spaziatrice"
        self.message.isHidden = false;
        self.lecterLeft.isHidden = true;
        self.lecterRight.isHidden = true;
        self.cross.isHidden = true;
    }
    
    func startGame(){
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
            let seconds = Double.random(in: 2.0..<3.5)
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
            self.lecterLeft.frame.origin.x = CGFloat(cross.frame.origin.x - 200 - CGFloat(self.changeDegree))
            self.lecterLeft.isHidden = false
            showLeft += 1
        }
        else if(self.showRight<self.limit){
            self.number = 1;
            if(self.block == 0){ self.lecterRight.stringValue = dct[8+self.showRight]}
            else {self.lecterRight.stringValue = dct[self.showRight]}
            self.lecterRight.frame.origin.x = CGFloat(cross.frame.origin.x + 200 + CGFloat(self.changeDegree))
            self.lecterRight.isHidden = false
            showRight += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.lecterLeft.isHidden = true;
            self.lecterRight.isHidden = true;
        }
    }
    
    func letterMiddle(){
        self.message.isHidden = true;
        self.cross.isHidden = true;
        if(self.number==0){
            self.lecterLeft.frame.origin.x = CGFloat(cross.frame.origin.x)
            self.lecterLeft.isHidden = false;
        }
        else{
            self.lecterRight.frame.origin.x = CGFloat(cross.frame.origin.x)
            self.lecterRight.isHidden = false;
        }
        self.phase = 1
    }
    
    func checkEnd(){
        if(self.block < 1){
            self.block += 1;
            NSEvent.removeMonitor(self.monitor!)
            self.begin();
        }
        else {
             NSEvent.removeMonitor(self.monitor!)
            NSApplication.shared.terminate(self)
        }
    }
    
    override func keyDown(with event: NSEvent) // A key is pressed
    {
        //controlla se la space bar è stata premuta
        switch event.keyCode {
        case 49:
            switch self.phase {
            case 0:
                self.startGame()
            case 1:
                self.initGame()
            case 2:
                self.letterMiddle()
            default:
                print("no")
            }
        case 53:
            //self.presentingViewController?.dismiss(self)
            NSApplication.shared.terminate(self)
        
        default:
        print("nothing")
    }
    }
}
    
    
   
       
       
   
       
       

 

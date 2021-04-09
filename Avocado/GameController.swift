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
    var toStart: Int!;
    var block: Int! = 0;
    let limit: Int! = 8;
    var lecter: Int! = 0;
    var dct1: [Character] = ["B","C","D","F","G","H","L","M","N","P","Q","R","S","T","V","Z"].shuffled()
    var dct2: [Character] = ["B","C","D","F","G","H","L","M","N","P","Q","R","S","T","V","Z"].shuffled()
    var monitor: Any?
    var optionsDictionary: [NSView.FullScreenModeOptionKey:Any]!
    
    @IBOutlet weak var message: NSTextField!
    @IBOutlet weak var lecterRight: NSImageView!
    @IBOutlet weak var lecterLeft: NSImageView!
    @IBOutlet weak var cross: NSImageView!
    
    override func viewWillDisappear() {
        NSApplication.shared.terminate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        begin();
    }

    
    func begin(){
        self.toStart = 1;
        self.message.stringValue = "premi la barra spaziatrice"
        
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
        self.toStart = 0;
        self.showLeft = 0;
        self.showRight = 0;
        self.message.isHidden = true;
        self.cross.isHidden = false;
        initGame();
    }
    
    
    override func viewDidAppear() {
        if(degree == 1){
            self.changeDegree = 200
        }
        view.window?.toggleFullScreen(self)
        self.lecterLeft.frame.origin.x = CGFloat(cross.frame.origin.x - 200 - CGFloat(self.changeDegree))
        self.lecterRight.frame.origin.x = CGFloat(cross.frame.origin.x + 200 + CGFloat(self.changeDegree))

        NSCursor.hide()
    
    }
    
    func initGame(){
   
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
    }
    
    func changeLecter(){
        self.number = Int.random(in: 0..<2)
        if( self.showLeft<self.limit) && (number == 0 || self.showRight == self.limit){
            self.number = 0;
            self.lecterLeft.isHidden = false
        }
        else if(self.showRight<self.limit){
            self.lecterRight.isHidden = false
            self.number = 1;
        }
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.lecterLeft.isHidden = true;
            self.lecterRight.isHidden = true;
            self.initGame()
        }

      
      
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
            if(self.toStart == 1) {self.startGame()}
            else {
            //calcola i tempi di risposta in milli secondi
               
            // scarta il valore
            if(ms>=150 && ms<=700){
                print(names[block]+String(number)+": "+String(Int(ms)))
                dct[names[block]+String(number)]?.append(Int(ms));
                if(number == 0){showLeft += 1}
                else {showRight += 1}
 }
            }
        case 53:
            //self.presentingViewController?.dismiss(self)
            NSApplication.shared.terminate(self)
        
        default:
        print("nothing")
    }
    }
}
    
    
   
       
       
   
       
       

 

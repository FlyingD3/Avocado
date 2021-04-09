//
//  ViewController.swift
//  Kiwi
//
//  Created by Lucio Busà on 16/03/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var googleButton: NSButton!
    @IBOutlet weak var degree: NSPopUpButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let gameController = segue.destinationController as! GameController
        gameController.degree = self.degree.indexOfSelectedItem
    }

    

    
    
    
    
}


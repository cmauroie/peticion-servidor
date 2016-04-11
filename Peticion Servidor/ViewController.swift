//
//  ViewController.swift
//  Peticion Servidor
//
//  Created by Carlos Mauricio Idárraga Espitia on 4/8/16.
//  Copyright © 2016 Carlos Mauricio Idárraga Espitia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var outLibro: UITextView!
    @IBOutlet weak var editLibro: UITextField!
    
   // @IBOutlet weak var searchBar: UISearchBar!
    
    var txtValue: UITextField?!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editLibro.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func BtnBuscar(sender: AnyObject) {
               async(editLibro.text!)
    }
    

    @IBAction func BtnLimpiar(sender: AnyObject) {
         outLibro.text = "-------------";
         editLibro.text = "";
    }
    //978-84-376-0494-7    
    func async(isbn:String){
        
        let urls:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
       //  let urls:String = "\(isbn)"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
            
            (datos : NSData?, resp : NSURLResponse?, error : NSError?) -> Void in
            
            if error != nil {
                //callback(“”, error.localizedDescription)
                dispatch_sync(dispatch_get_main_queue()) {
                    self.setInfo("")
                   
                }
            } else {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                print(texto)
                dispatch_sync(dispatch_get_main_queue()) {
                    self.setInfo(String(texto))
                   
                }
            }
            
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        print("antes o despues")
    }
    
    
    func setInfo(msj: String){
        
        if(msj != ""){
            outLibro.text=String(msj)
        }else{
            let alertController = UIAlertController(title: "", message:
                "Por favor revisa tu conexión a internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         async(editLibro.text!)
        return true
    }
}




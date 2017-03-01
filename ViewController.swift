//
//  ViewController.swift
//  ChildManagerApp
//
//  Created by Haim Gabay on 26/09/2016.
//  Copyright © 2016 Haim Gabay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDataDelegate, URLSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var lblHeadline: UILabel! = nil;
    var btnLogin: UIButton! = nil;
    var btnSignUp: UIButton! = nil;
    var image: UIImage!;
    var imageContainer: UIImageView!;
    var session: URLSession! = nil;
    var url: URL!;
    let action = "login";
    var userName = "haim11";
    var password = "gabay22";
    var signupKidsController: SignupKidsController!;
    var signupUserController: SignupUserController!;
    var userChildsList: UserChildsList!;
    var picturePicker: UIImagePickerController!;
    var appDelegate: AppDelegate!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController = self;
        //HEADLINE LABEL:
        lblHeadline = UILabel(frame: CGRect(x: 0, y: 60, width: view.frame.width - 150, height: 30));
        lblHeadline.textColor = UIColor.blue;
        lblHeadline.text = "Welcome To your Child's App";
        lblHeadline.center.x = view.center.x;
        lblHeadline.textAlignment = .center;
        view.addSubview(lblHeadline);
        //IMAGE & CONTAINER:
        imageContainer = UIImageView(frame: CGRect(x: 0, y: 100, width: view.frame.width - 100, height: view.frame.height - 200));
        imageContainer.center.x = view.center.x;
        image = UIImage(contentsOfFile: getImage());
        imageContainer.image = image;
        view.addSubview(imageContainer);
        //TAP GESTURE RECOGNIZER:
        let frame = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width - 100, height: view.frame.height - 200));
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.chooseImageByUser(_:)));
        view.addSubview(frame);
        frame.addGestureRecognizer(tapGestureRecognizer);
        //BUTTONS:
        btnLogin = UIButton(type: .system);
        btnLogin.frame = CGRect(x: 50, y: imageContainer.frame.maxY + 10, width: view.frame.width/2 - 55, height: 40);
        btnLogin.setTitle("Login", for: .normal);
        btnLogin.tag = 1;
        btnLogin.addTarget(self, action: #selector(ViewController.login(_:)), for: .touchUpInside);
        view.addSubview(btnLogin);
        ////
        btnSignUp = UIButton(type: .system);
        btnSignUp.frame = CGRect(x: btnLogin.frame.maxX + 10, y: imageContainer.frame.maxY + 10, width: view.frame.width/2 - 55, height: 40);
        btnSignUp.setTitle("SignUp", for: .normal);
        btnSignUp.tag = 2;
        btnSignUp.addTarget(self, action: #selector(self.signUp(_:)), for: .touchUpInside);
        view.addSubview(btnSignUp);
        //IMAGE PICKER:
        picturePicker = UIImagePickerController();
        picturePicker.sourceType = .photoLibrary;
        picturePicker.delegate = self;
        //URL_SESSION:
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration);
        url = URL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
    }
    
    func login(_ sender: UIButton){
        
        btnSignUp.isEnabled = false;
        btnLogin.isEnabled = false;
        lblHeadline.text = "verifying...";
        
        let httpRequest = NSMutableURLRequest(url: url);
        httpRequest.httpMethod = "POST";
        
        let loginDict: [String: String] =
            [
                "action": action, 
                "userName": userName,
                "password": password
            ]
        do{
            let d = try JSONSerialization.data(withJSONObject: loginDict, options: .prettyPrinted);
              let task = session.uploadTask(with: httpRequest as URLRequest!, from: d, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil{
                    if let theData = data{
                        if (theData.count) > 0{
                            print(theData);
                            do{
                                let dictResponse = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as! [String: String];
                                print(dictResponse);
                                let result = dictResponse["result"]!;
                                if result == "success"{
                                print("success");
                                }
                           }catch{
                                    print("error handling data");
                            }
                                let mainQueue = DispatchQueue.main;
                                mainQueue.async {
                                self?.lblHeadline.text = "welcome!!!";
                                self?.btnSignUp.isEnabled = true;
                                self?.btnLogin.isEnabled = true;
                            }
                        }
                    }
                }
            });
            task.resume();
        }catch{
            print("error sending info to server");
        }
        signupKidsController = SignupKidsController();
        present(signupKidsController, animated: true, completion: nil);
    }
    func signUp(_ sender: UIButton){
        if signupUserController == nil{
            signupUserController = SignupUserController();
            present(signupUserController, animated: true, completion: nil);
        }else{
             present(signupUserController, animated: true, completion: nil);
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil);
        image = (info["UIImagePickerControllerOriginalImage"]! as! UIImage);
        saveImageDocumentDirectory(image: image);
    }
    
    func saveImageDocumentDirectory(image: UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("loginImage.png");
        print(paths);
        let imageData = UIImageJPEGRepresentation(image, 0.5);
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil);
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let documentsDirectory = paths[0];
        return documentsDirectory;
    }
    
    func getImage()->String{
        let fileManager = FileManager.default;
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent("loginImage.png");
        if fileManager.fileExists(atPath: imagePath){
            self.imageContainer.image = UIImage(contentsOfFile: imagePath);
        }else{
            print("No Image");
        }
        return imagePath;
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
    }
    
    func chooseImageByUser(_ sender: UITapGestureRecognizer){
        imagePickerFunc();
    }
    func imagePickerFunc(){
        present(picturePicker, animated: true, completion: nil);
    }
}

//
//  SignupUserController.swift
//  ChildManagerApp
//
//  Created by Haim Gabay on 21/10/2016.
//  Copyright © 2016 Haim Gabay. All rights reserved.
//

import UIKit

class SignupUserController: UIViewController, URLSessionDataDelegate, URLSessionDelegate {
    var txtUsername: UITextField!;
    var txtPassword: UITextField!;
    var userName: String!;
    var password: String!;
    var buttonAddChildForUSer: UIButton!;
    var signupKidsController: SignupKidsController!;
    var buttonGoBack: UIButton!;
    var session: URLSession! = nil;
    var url: URL!;
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white;
        //BACK BUTTON:
        buttonGoBack = UIButton(type: .system);
        buttonGoBack.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        buttonGoBack.addTarget(self, action: #selector(self.goToFirstViewController(_:)), for: .touchUpInside);
        view.addSubview(buttonGoBack);
        let imageForBackButtun = UIImage(named: "back-button");
        let imageView = UIImageView(image: imageForBackButtun);
        imageView.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        view.addSubview(imageView);
        //HEADLINE:
        let headline = UILabel(frame: CGRect(x: 10, y: view.center.y - 100, width: view.frame.width - 20, height: 30));
        headline.text = "please enter your details here:";
        headline.textColor = UIColor.blue;
        headline.textAlignment = .center;
        view.addSubview(headline);
        //TEXTFIELDS:
        txtUsername = UITextField(frame: CGRect(x: 25, y: headline.frame.maxY + 20, width: view.frame.width - 50, height: 30));
        txtUsername.placeholder = "username";
        txtUsername.borderStyle = .roundedRect;
        txtUsername.text = "haim11";
        view.addSubview(txtUsername);
        txtPassword = UITextField(frame: CGRect(x: 25, y: txtUsername.frame.maxY + 10, width: view.frame.width - 50, height: 30));
        txtPassword.placeholder = "password";
        txtPassword.borderStyle = .roundedRect;
        txtPassword.text = "gabay22";
        view.addSubview(txtPassword);
        //BUTTONS:
        buttonAddChildForUSer = UIButton(type: .system);
        buttonAddChildForUSer.frame = CGRect(x: view.frame.width/2 - 25, y: txtPassword.frame.maxY + 25, width: 50, height: 45);
        buttonAddChildForUSer.setTitle("Done", for: .normal);
        buttonAddChildForUSer.addTarget(self, action: #selector(SignupUserController.goToAddChildController(_:)), for: .touchUpInside);
        view.addSubview(buttonAddChildForUSer);
        //URL_SESSION:
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration);
        url = URL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
    }
    func goToFirstViewController(_ sender: UIButton){
        dismiss(animated: true, completion: nil);
    }
    func goToAddChildController(_ sender: UIButton){
        buttonAddChildForUSer.isEnabled = false;
        userName = txtUsername.text;
        password = txtPassword.text;
        let httpRequest = NSMutableURLRequest(url: url);
        httpRequest.httpMethod = "POST";
        
        let userDict: [String: String] =
            [
             "action" : "login",
             "username" : userName,
             "password" : password
        ] 
        do{
            let signupData = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted);
                let task = session.uploadTask(with: httpRequest as URLRequest, from: signupData, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                    if error == nil{
                        if let theData = data{
                            if theData.count > 0{
                              
                                do{
                                    let dictResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String];
                                        let success = "success";
                                            if success == "success"{
                                    }
                         
                                }catch{
                                    print("error handling incoming dict");
                                }
                                if self!.signupKidsController == nil{
                                    self!.signupKidsController = SignupKidsController();
                                }
                            DispatchQueue.main.async {
                                self!.buttonAddChildForUSer.isEnabled = true;
                                self!.present(self!.signupKidsController, animated: true, completion: nil);
                                self!.buttonAddChildForUSer.isEnabled = true;
                            }
                            
                        }
                  }
                    }else{
                        print("server error");
                    }
            });
            task.resume();
        }catch{
            print("error serializing signupData");
        }
      
    }
}

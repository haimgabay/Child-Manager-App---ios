//
//  SignupController.swift
//  ChildManagerApp
//
//  Created by Haim Gabay on 03/10/2016.
//  Copyright © 2016 Haim Gabay. All rights reserved.
//

import UIKit

class SignupKidsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, URLSessionDataDelegate, URLSessionDelegate{
    
    var childName: String?;
    var dateOfBirth: String?;
    var birthHeight: String?;
    var birthWeight: String?;
    var sex: String?;
    var imageToShow: UIImage!;
    var imageContainer: UIImageView!;
    var btnAddMoreChild: UIButton!;
    var headlineLabel: UILabel!;
    var secondaryLabel: UILabel!;
    var txtFieldChildName: UITextField!;
    var txtFieldDateOfBirth: UITextField!;
    var txtFieldBirthHeight: UITextField!;
    var txtFieldBirthWeight: UITextField!;
    var txtFieldSex: UITextField!;
    var picturePicker: UIImagePickerController!;
    var buttonImagePicker: UIButton!;
    var buttonAddChild: UIButton!;
    var buttonGoBack: UIButton!;
    var buttonDone: UIButton!;
    var buttonSaveAllChildsAndExit: UIButton!;
    var buttonGoToUserChildsList: UIButton!;
    var childsDetails: [ChildDetails]!;
    var alertController: UIAlertController!;
    var txtFieldsArray = [UITextField]();
    var session: URLSession! = nil;
    var url: URL!;
    var currentChild = 0;
    var userChildsController: UserChildsList!;
    
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
        headlineLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 30));
        headlineLabel.text = "Hello And Welcome!!!";
        headlineLabel.textAlignment = .center;
        headlineLabel.textColor = UIColor.blue;
        view.addSubview(headlineLabel);
        //SECOND HEADLINE:
        secondaryLabel = UILabel(frame: CGRect(x: 0, y: headlineLabel.frame.maxY, width: view.frame.width, height: 30));
        secondaryLabel.text = "Please Insert Your Child Details Below:"
        secondaryLabel.textAlignment = .center;
        secondaryLabel.textColor = UIColor.blue;
        view.addSubview(secondaryLabel);
        //TEXTFIELDS:
        txtFieldChildName = UITextField(frame: CGRect(x: 10, y: secondaryLabel.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldChildName.borderStyle = .roundedRect;
        txtFieldChildName.placeholder = "Child's Name";
        txtFieldChildName.returnKeyType = .next;
        txtFieldChildName.delegate = self;
        txtFieldChildName.tag = 0;
         view.addSubview(txtFieldChildName);
        txtFieldDateOfBirth = UITextField(frame: CGRect(x: 10, y: txtFieldChildName.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldDateOfBirth.borderStyle = .roundedRect;
        txtFieldDateOfBirth.placeholder = "Date Of Birth";
        txtFieldDateOfBirth.returnKeyType = .next;
        txtFieldDateOfBirth.delegate = self;
        txtFieldDateOfBirth.tag = 1;
         view.addSubview(txtFieldDateOfBirth);
        txtFieldBirthHeight = UITextField(frame: CGRect(x: 10, y: txtFieldDateOfBirth.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldBirthHeight.borderStyle = .roundedRect;
        txtFieldBirthHeight.placeholder = "Birth Height";
        txtFieldBirthHeight.returnKeyType = .next;
        txtFieldBirthHeight.delegate = self;
        txtFieldBirthHeight.tag = 2;
         view.addSubview(txtFieldBirthHeight);
        txtFieldBirthWeight = UITextField(frame: CGRect(x: 10, y: txtFieldBirthHeight.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldBirthWeight.borderStyle = .roundedRect;
        txtFieldBirthWeight.placeholder = "Birth Weight";
        txtFieldBirthWeight.returnKeyType = .next;
        txtFieldBirthWeight.delegate = self;
        txtFieldBirthWeight.tag = 3;
         view.addSubview(txtFieldBirthWeight);
        txtFieldSex = UITextField(frame: CGRect(x: 10, y: txtFieldBirthWeight.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldSex.borderStyle = .roundedRect;
        txtFieldSex.placeholder = "Boy/Girl";
        txtFieldSex.returnKeyType = .next;
        txtFieldSex.delegate = self;
        txtFieldSex.tag = 4;
         view.addSubview(txtFieldSex);
        //TEXTFIELDS ARRAY:
        txtFieldsArray.append(txtFieldChildName);
        txtFieldsArray.append(txtFieldDateOfBirth);
        txtFieldsArray.append(txtFieldBirthHeight);
        txtFieldsArray.append(txtFieldBirthWeight);
        txtFieldsArray.append(txtFieldSex);
        //IMAGE PICKER:
        picturePicker = UIImagePickerController();
        picturePicker.sourceType = .photoLibrary;
        picturePicker.delegate = self;
        //IMAGE:
        imageToShow = UIImage(named: "imagePlaceholder");
        imageContainer = UIImageView(frame: CGRect(x: 10, y: txtFieldSex.frame.maxY + 10, width: view.frame.width/4, height: view.frame.width/4 + 20));
        imageContainer.image = imageToShow;
        view.addSubview(imageContainer);
        //BUTTONS:
        buttonImagePicker = UIButton(type: .system);
        buttonImagePicker.frame = CGRect(x: 10, y: txtFieldSex.frame.maxY + 10, width: view.frame.width/4, height: view.frame.width/4 + 20);
        buttonImagePicker.addTarget(self, action: #selector(SignupKidsController.imagePickerFunc(_:)), for: .touchUpInside);
        view.addSubview(buttonImagePicker);
        ///////
        buttonDone = UIButton(type: .system);
        buttonDone.frame = CGRect(x: buttonImagePicker.frame.maxX + 100, y: buttonImagePicker.frame.minY, width: 50, height: 30);
        buttonDone.setTitle("Done", for: .normal);
        buttonDone.addTarget(self, action: #selector(SignupKidsController.doneAddingfunc(_:)), for: .touchUpInside);
        view.addSubview(buttonDone);
        ///////
        buttonAddChild = UIButton(type: .system);
        buttonAddChild.frame = CGRect(x: buttonDone.frame.minX, y: buttonDone.frame.maxY + 10, width: 50, height: 30);
        buttonAddChild.setTitle("Add +", for: .normal);
        buttonAddChild.addTarget(self, action: #selector(SignupKidsController.buttonAddChild(_:)), for: .touchUpInside);
        view.addSubview(buttonAddChild);
        ///////
        buttonSaveAllChildsAndExit = UIButton(type: .system);
        buttonSaveAllChildsAndExit.frame = CGRect(x: buttonAddChild.frame.minX - 65, y: buttonAddChild.frame.maxY + 10, width: 170, height: 30);
        buttonSaveAllChildsAndExit.setTitle("SAVE ALL & EXIT", for: .normal);
        buttonSaveAllChildsAndExit.addTarget(self, action: #selector(SignupKidsController.buttonSaveAllChildsAndExit(_:)), for: .touchUpInside);
        view.addSubview(buttonSaveAllChildsAndExit);
        buttonAddChild.isEnabled = false;
        buttonSaveAllChildsAndExit.isEnabled = false;
        ///////
        buttonGoToUserChildsList = UIButton(type: .system);
        buttonGoToUserChildsList.setTitle("My Child's List", for: .normal);
        buttonGoToUserChildsList.addTarget(self, action: #selector(SignupKidsController.buttonMyChildsList(_:)), for: .touchUpInside);
        buttonGoToUserChildsList.frame = CGRect(x: buttonSaveAllChildsAndExit.frame.minX - 20, y: buttonSaveAllChildsAndExit.frame.maxY + 30, width: 110, height: 30);
        buttonGoToUserChildsList.isEnabled = false;
        view.addSubview(buttonGoToUserChildsList);
        //CHILD'S ARRAY:
        childsDetails = [ChildDetails]();
        //DISMISS THE KEYBOARD:
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupKidsController.dismissKeyboard(_:)));
        view.addGestureRecognizer(tapGestureRecognizer);
        //URL SESSION&CONFIGURATION:
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration);
        url = URL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag);
        if textField.tag == 4{
            imagePickerFunc();
        }else{
        for  i in 0..<4{
            if textField.tag == i{
                textField.resignFirstResponder();
                txtFieldsArray[i+1].becomeFirstResponder();
            }
          }
        }
            return false;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil);
        print("image picked");
        imageContainer.image = (info["UIImagePickerControllerOriginalImage"]! as! UIImage);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil);
    }
    
    func imagePickerFunc(_ sender: UIButton){
        present(picturePicker, animated: true, completion: nil);
    }
    
    func imagePickerFunc(){
        present(picturePicker, animated: true, completion: nil);
    }
    
    func goToFirstViewController(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    func buttonAddChild(_ sender: UIButton){
        doneAddingfunc(sender);
        self.currentChild += 1;
    }
    
    func doneAddingfunc(_ sender: UIButton){
        buttonDone.isEnabled = false;
        buttonGoToUserChildsList.isEnabled = true;
        //TEMPORARY ALTERNATIVE TO USER VALIDITY CHECK (ON SERVER):
        if (!(txtFieldChildName.text?.isEqual(childName))! || !(txtFieldDateOfBirth.text?.isEqual(dateOfBirth))! || !(txtFieldBirthHeight.text?.isEqual(birthHeight))! || !(txtFieldBirthWeight.text?.isEqual(birthWeight))!){   //if one of fields not matching to previouse child
                childName = txtFieldChildName.text;
                dateOfBirth = txtFieldDateOfBirth.text;
                birthHeight = txtFieldBirthHeight.text;
                birthWeight = txtFieldBirthWeight.text;
                sex = txtFieldSex.text;
                let image = imageContainer.image;
            if (childName!.isEmpty && dateOfBirth!.isEmpty && birthHeight!.isEmpty && birthWeight!.isEmpty && sex!.isEmpty){ //if all empty
                    secondaryLabel.text = "error - enter parameters for all fields!!!";
                    secondaryLabel.textColor = UIColor.red;
                    buttonDone.isEnabled = true;
            }else if (!childName!.isEmpty && !dateOfBirth!.isEmpty && !birthHeight!.isEmpty && !birthWeight!.isEmpty && !sex!.isEmpty){ //if all filled
                childsDetails.append(ChildDetails(childName: self.childName!, dateOfBirth: self.dateOfBirth!, birthHeight: self.birthHeight!, birthWeight: self.birthWeight!, sex: self.sex!, imageOfChild: image!));
                print(childsDetails.count);
                secondaryLabel.text = "Please Insert Your Child Details Below:";
                secondaryLabel.textColor = UIColor.blue;
                buttonDone.isEnabled = true;
            if alertController == nil{
                    alertController = UIAlertController(title: "Success!!", message: "you added your child...", preferredStyle: .alert);
                    let actionDone = UIAlertAction(title: "OK", style: .default, handler: nil);
                    alertController.addAction(actionDone);
                }
            present(alertController, animated: true, completion: nil);
            imageContainer.image = imageToShow;
            secondaryLabel.text = "you can insert another child details now...";
            txtFieldChildName.text = "";
            txtFieldDateOfBirth.text = "";
            txtFieldBirthHeight.text = "";
            txtFieldBirthWeight.text = "";
            txtFieldSex.text = "";
        }else{
            secondaryLabel.text = "error - enter parameters for all fields!!!";
            secondaryLabel.textColor = UIColor.red;
            buttonDone.isEnabled = true;
        }
        }else{
            if(childName!.isEmpty && dateOfBirth!.isEmpty && birthHeight!.isEmpty && birthWeight!.isEmpty && sex!.isEmpty){ //all empty
                secondaryLabel.text = "error - enter parameters for all fields!!!";
                secondaryLabel.textColor = UIColor.red;
                buttonDone.isEnabled = true;
            }else{
                secondaryLabel.text = "error - child is already exists!!!";
                secondaryLabel.textColor = UIColor.red;
                let mainQueue = DispatchQueue.main;
                mainQueue.async {
                self.buttonDone.isEnabled = true;
                self.buttonAddChild.isEnabled = true;
                self.buttonSaveAllChildsAndExit.isEnabled = true;
            
            }
        }
      }
        let mainQueue = DispatchQueue.main;
        mainQueue.async {
            self.buttonDone.isEnabled = true;
            self.buttonAddChild.isEnabled = true;
            self.buttonSaveAllChildsAndExit.isEnabled = true;
        }
    }
    func dismissKeyboard(_ sender: UITapGestureRecognizer){
        for var i in 0..<txtFieldsArray.count{
            if txtFieldsArray[i].isFirstResponder{
                txtFieldsArray[i].resignFirstResponder();
            }
        }
    }
    func buttonMyChildsList(_ sender: UIButton){
        if userChildsController == nil{
            userChildsController = UserChildsList();
            userChildsController.data = self.childsDetails;
        }else{
            if childsDetails.count != userChildsController.data.count{
                userChildsController.data = childsDetails;
                userChildsController.tableOfChilds.reloadData();
            }
        }
                present(userChildsController, animated: true, completion: nil);
    }
    func buttonSaveAllChildsAndExit(_ sender: UIButton){
        buttonDone.isEnabled = false;
        buttonAddChild.isEnabled = false;
        buttonSaveAllChildsAndExit.isEnabled = false;
        buttonGoBack.isEnabled = false;
        headlineLabel.text = "Checking Validity...";
        secondaryLabel.text = "";
        
        let httpRequest = NSMutableURLRequest(url: url);
        httpRequest.httpMethod = "POST";
        
        let kidsdict :[String: String] =
            [
                "childName" : childsDetails[currentChild].childName,
                "dateOfBirth" : childsDetails[currentChild].dateOfBirth,
                "birthHeight" : childsDetails[currentChild].birthHeight,
                "birthWeight" : childsDetails[currentChild].birthWeight,
                "sex" : childsDetails[currentChild].sex
            ];
        print(kidsdict);
        do{
            let d = try JSONSerialization.data(withJSONObject: kidsdict, options: .prettyPrinted);
            print(d);
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
                                self!.headlineLabel.text = "Child Added!";
                                self!.buttonDone.isEnabled = true;
                                self!.buttonAddChild.isEnabled = true;
                                self!.buttonSaveAllChildsAndExit.isEnabled = true;
                                self!.buttonGoBack.isEnabled = true;
                            }
                            
                        }
                    }
                }
            });
            task.resume();
        }catch{
            print("error sending info to server");
        }
        self.currentChild += 1;
    }

}

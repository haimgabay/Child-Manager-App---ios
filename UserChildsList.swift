//
//  UserChildsList.swift
//  ChildManagerApp
//
//  Created by Haim Gabay on 08/11/2016.
//  Copyright © 2016 Haim Gabay. All rights reserved.
//

import UIKit

class UserChildsList: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var tableOfChilds: UITableView!;
    var data: [ChildDetails]!;
    let identifier = "identifier";
    var editView: UIView!;
    var headlineLabel: UILabel!;
    var txtFieldChildName: UITextField!;
    var txtFieldDateOfBirth: UITextField!;
    var txtFieldBirthHeight: UITextField!;
    var txtFieldBirthWeight: UITextField!;
    var txtFieldSex: UITextField!;
    var picturePicker: UIImagePickerController!;
    var buttonImagePicker: UIButton!;
    var imageToShow: UIImage!;
    var imageContainer: UIImageView!;
    var buttonDone: UIButton!;
    var session: URLSession! = nil;
    var url: URL!;
    var indexPath: IndexPath!;
    var buttonGoToSleepController: UIButton!;
    var sleepActivityController: SleepActivityManager!;
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white;
        //LABEL:
        let labelInfo = UILabel(frame: CGRect(x: view.frame.width / 2 - 140 , y: 35, width: 280, height: 25));
        labelInfo.text = "you can tap on child to edit details";
        labelInfo.textAlignment = .center;
        labelInfo.textColor = UIColor.green;
        view.addSubview(labelInfo);
        //TABLE VIEW:
        let frame = CGRect(x: 0, y: 65, width: view.frame.width, height: view.frame.height - 65);
        tableOfChilds = UITableView(frame: frame, style: .plain);
        tableOfChilds.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier);
        tableOfChilds.dataSource = self;
        tableOfChilds.delegate = self;
        view.addSubview(tableOfChilds);
        //EDIT VIEW:
        editView = UIView(frame: view.frame);
        editView.backgroundColor = UIColor.white;
        //HEADLINE:
        headlineLabel = UILabel(frame: CGRect(x: 0, y: 30, width: view.frame.width, height: 30));
        headlineLabel.text = "you can edit Your Child Details Below:"
        headlineLabel.textAlignment = .center;
        headlineLabel.textColor = UIColor.blue;
        editView.addSubview(headlineLabel);
        //TEXTFIELDS:
        txtFieldChildName = UITextField(frame: CGRect(x: 10, y: headlineLabel.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldChildName.borderStyle = .roundedRect;
        txtFieldChildName.placeholder = "Child's Name";
        txtFieldChildName.returnKeyType = .next;
        txtFieldChildName.delegate = self;
        txtFieldChildName.tag = 0;
        editView.addSubview(txtFieldChildName);
        txtFieldDateOfBirth = UITextField(frame: CGRect(x: 10, y: txtFieldChildName.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldDateOfBirth.borderStyle = .roundedRect;
        txtFieldDateOfBirth.placeholder = "Date Of Birth";
        txtFieldDateOfBirth.returnKeyType = .next;
        txtFieldDateOfBirth.delegate = self;
        txtFieldDateOfBirth.tag = 1;
        editView.addSubview(txtFieldDateOfBirth);
        txtFieldBirthHeight = UITextField(frame: CGRect(x: 10, y: txtFieldDateOfBirth.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldBirthHeight.borderStyle = .roundedRect;
        txtFieldBirthHeight.placeholder = "Birth Height";
        txtFieldBirthHeight.returnKeyType = .next;
        txtFieldBirthHeight.delegate = self;
        txtFieldBirthHeight.tag = 2;
        editView.addSubview(txtFieldBirthHeight);
        txtFieldBirthWeight = UITextField(frame: CGRect(x: 10, y: txtFieldBirthHeight.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldBirthWeight.borderStyle = .roundedRect;
        txtFieldBirthWeight.placeholder = "Birth Weight";
        txtFieldBirthWeight.returnKeyType = .next;
        txtFieldBirthWeight.delegate = self;
        txtFieldBirthWeight.tag = 3;
        editView.addSubview(txtFieldBirthWeight);
        txtFieldSex = UITextField(frame: CGRect(x: 10, y: txtFieldBirthWeight.frame.maxY + 10, width: view.frame.width - 20, height: 30));
        txtFieldSex.borderStyle = .roundedRect;
        txtFieldSex.placeholder = "Boy/Girl";
        txtFieldSex.returnKeyType = .next;
        txtFieldSex.delegate = self;
        txtFieldSex.tag = 4;
        editView.addSubview(txtFieldSex);
        //IMAGE PICKER:
        picturePicker = UIImagePickerController();
        picturePicker.sourceType = .photoLibrary;
        picturePicker.delegate = self;
        //IMAGE:
        imageToShow = UIImage(named: "imagePlaceholder");
        imageContainer = UIImageView(frame: CGRect(x: 10, y: txtFieldSex.frame.maxY + 10, width: 80, height: 100));
        imageContainer.image = imageToShow;
        editView.addSubview(imageContainer);
        //BUTTONS:
        buttonImagePicker = UIButton(type: .system);
        buttonImagePicker.frame = CGRect(x: 10, y: txtFieldSex.frame.maxY + 10, width: view.frame.width/4, height: view.frame.width/4 + 20);
        buttonImagePicker.addTarget(self, action: #selector(SignupKidsController.imagePickerFunc(_:)), for: .touchUpInside);
        editView.addSubview(buttonImagePicker);
        ///////
        buttonDone = UIButton(type: .system);
        buttonDone.frame = CGRect(x: buttonImagePicker.frame.maxX + 100, y: buttonImagePicker.frame.minY, width: 50, height: 30);
        buttonDone.setTitle("Done", for: .normal);
        buttonDone.addTarget(self, action: #selector(UserChildsList.doneEditingfunc(_:)), for: .touchUpInside);
        editView.addSubview(buttonDone);
        //BACK BUTTON:
        let buttonGoBack = UIButton(type: .system);
        buttonGoBack.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        buttonGoBack.addTarget(self, action: #selector(self.goToPreviousViewController(_:)), for: .touchUpInside);
        view.addSubview(buttonGoBack);
        let imageForBackButtun = UIImage(named: "back-button");
        let imageView = UIImageView(image: imageForBackButtun);
        imageView.frame = CGRect(x: 10, y: 30, width: 30, height: 30);
        view.addSubview(imageView);
        //BUTTON GO TO SLEEP CONTROLLER:
        buttonGoToSleepController = UIButton(type: .system);
        buttonGoToSleepController.frame = CGRect(x: buttonDone.frame.midX - 150, y: buttonDone.frame.maxY + 15, width: 300, height: 45);
        buttonGoToSleepController.setTitle("SLEEPING FOLLW-UP", for: .normal);
        buttonGoToSleepController.addTarget(self, action: #selector(self.goToSleepViewController(_:)), for: .touchUpInside);
        editView.addSubview(buttonGoToSleepController);
        //URL SESSION & CONFIGURATION:
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration);
        url = URL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath;
        txtFieldChildName.text = data[indexPath.row].childName;
        txtFieldDateOfBirth.text = data[indexPath.row].dateOfBirth;
        txtFieldBirthHeight.text = data[indexPath.row].birthHeight;
        txtFieldBirthWeight.text = data[indexPath.row].birthWeight;
        txtFieldSex.text = data[indexPath.row].sex;
        imageContainer.image = data[indexPath.row].imageOfChild;
        view.addSubview(editView);
        
    }
    func doneEditingfunc(_ sender: UIButton){
        buttonDone.isEnabled = false;
        data[indexPath.row].childName = txtFieldChildName.text!;
        data[indexPath.row].imageOfChild = imageContainer.image!;
        tableOfChilds.reloadRows(at: [indexPath], with: UITableViewRowAnimation.left);
        let httpRequest = NSMutableURLRequest(url: url);
        httpRequest.httpMethod = "POST";
        
        let kidsdict :[String: String] =
            [
                "childName" : data[indexPath.row].childName,
                "dateOfBirth" : data[indexPath.row].dateOfBirth,
                "birthHeight" : data[indexPath.row].birthHeight,
                "birthWeight" : data[indexPath.row].birthWeight,
                "sex" : data[indexPath.row].sex
        ];
        do{
            let editedKidData = try JSONSerialization.data(withJSONObject: kidsdict, options: .prettyPrinted);
            let task = session.uploadTask(with: httpRequest as URLRequest, from: editedKidData, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                if error == nil{
                    if let theData = data{
                        if theData.count > 0{
                            do{
                                let dictResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String];
                                let success = "success"; //dictResult["result"];
                                if success == "success"{
                                    DispatchQueue.main.async {
                                        self!.buttonDone.isEnabled = true;
                                        self!.view.willRemoveSubview(self!.editView);
                                    }
                                }
                            }catch{
                                print("error handling incoming dict");
                                DispatchQueue.main.async {
                                    self!.buttonDone.isEnabled = true;
                                    self!.editView.removeFromSuperview();
                                    
                                }
                            }
                        }
                    }
                }else{
                    print("server error");
                }
            });
            task.resume();
        }catch{
            print("error serializing incoming dict");
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
            if cell == nil{
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier);
                let lblKidsName = UILabel(frame: CGRect(x: 60, y: 7, width: 150, height: 30));
                lblKidsName.text! = data[indexPath.row].childName;
                cell!.imageView!.image = data[indexPath.row].imageOfChild;
                cell!.contentView.addSubview(lblKidsName);
                print("cell is nil");
            return cell!;
        }
        cell?.textLabel?.text = data[indexPath.row].childName;
        cell!.imageView?.image = data[indexPath.row].imageOfChild;
        return cell!;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            data.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .left);
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Kids:";
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "end of list ----"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil);
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
    func goToPreviousViewController(_ sender: UIButton){
        dismiss(animated: true, completion: nil);
    }
    func goToSleepViewController(_ sender: UIButton){
        doneEditingfunc(sender);
        sleepActivityController = SleepActivityManager();
        sleepActivityController.userChildList = self;
        sleepActivityController.childName = txtFieldChildName.text;
        sleepActivityController.imageOfChild = imageContainer.image!;
        present(sleepActivityController, animated: true, completion: nil);
    }
        
}

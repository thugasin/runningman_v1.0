////
////  LoginViewController_sf.swift
////  RunningMan_0.5
////
////  Created by Sirius on 15/11/4.
////  Copyright © 2015年 Sirius. All rights reserved.
////
//
//import UIKit
//
//class LoginViewController: UIViewController
//{
//    @IBOutlet var UserId : UITextField
//    @IBOutlet var Password : UITextField
//    @IBOutlet var loginButton : UIButton
//    
//    var aa : String
//    
//    @IBAction func OnLogin(sender : UIButton)
//    {
//        var na = NetworkAdapter(InitNetwork)
//        
//        var result: Bool;
//        if (aa != "")
//        {
//            result = true;
//        }
//        else
//        {
//            result = na.Connect(Connect1("ayo.org.cn"),Port:9090)
//            aa = "afsa";
//        }
//        
//        na.SubscribeMessage(SubscribeMessage1(LOGIN_RESULT),Instance:self)
//        
//        if (result)
//        {
//            var LoginMessage = String(format:"login 2\r\n%@\r\n%@\r\n", UserId.text, Password.text)
//            na.sendData(LoginMessage)
//        }
//
//    }
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        Password.placeholder = "密码"
//        UserId.placeholder = "用户名／手机号／邮箱号"
//        var buttonImage = UIImage(imageNamed:"loginButton.png")
//        loginButton.setBackgroundImage(setBackgroundImage1(buttonImage), forState:UIControlStateNormal)
//        loginButton.setBackgroundImage(setBackgroundImage1(buttonImage), forState:UIControlStateHighlighted)
//        aa = ""
//    }
//    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event:UIEvent)
//    {
//        self.view.endEditing(YES);
//    }
//
//}
//
//

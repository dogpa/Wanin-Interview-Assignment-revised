//
//  SignUpView.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/28.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode       //返回上一頁
    @State private var emailSignUp = ""                         //帳號
    @State private var firstPassword = ""                       //密碼
    @State private var confirmPassword = ""                     //再次輸入密碼
    @State private var title = ""                               //提示警告title
    @State private var message = ""                             //提示警告message
    @State private var alertIsPresentedToWarn = false           //是否跳警告視窗
    
    var body: some View {
        //signin text
        Text("SignUp")
            .fontWeight(.bold)
            .font(.system(size: 35))
            .padding()
            .frame(width: 400, height: 100, alignment: .leading)
        //註冊帳號email
        TextField("Input Email Address", text: $emailSignUp)
            .autocapitalization(.none)
            .padding()
            .frame(width: 300, height: 50, alignment: .center)
            .border(Color.black)
        //第一次密碼
        SecureField("Input Password", text: $firstPassword)
            .autocapitalization(.none)
            .padding()
            .frame(width: 300, height: 50, alignment: .center)
            .border(Color.black)
        //確認密碼
        SecureField("Confirm Password", text: $confirmPassword)
            .autocapitalization(.none)
            .padding()
            .frame(width: 300, height: 50, alignment: .center)
            .border(Color.black)
        //密碼規則text
        Text("密碼規則：\n至少一個英文及數字\n密碼長度至少8字元")
            .frame(width: 350, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        //MARK:註冊按鈕
        Button(action: {
            //檢查是否有錯誤
            //檢查是否都有輸入都有輸入檢查規格格式
            if emailSignUp.isEmpty != true,
               firstPassword.isEmpty != true,
               confirmPassword.isEmpty != true {
                if emailSignUp.range(of: "@") == nil || emailSignUp.range(of: ".") == nil {
                    alertInfo(switchBool: true, titleInfo: "Email格式錯誤", messageInfo: "請再次確認")
                }else if firstPassword.count < 8 {
                    alertInfo(switchBool: true, titleInfo: "密碼過短", messageInfo: "密碼需至少八位數")
                }else if firstPassword != confirmPassword {
                    alertInfo(switchBool: true, titleInfo: "密碼輸入不符", messageInfo: "兩次密碼不一致")
                }else if checkPasswordFollowRule(firstPassword) == true {
                    alertInfo(switchBool: true, titleInfo: "密碼未符合規範", messageInfo: "請確認密碼規則")
                }else{
                    Auth.auth().createUser(withEmail: emailSignUp, password: firstPassword) {result, error in
                        guard error == nil else {
                            alertInfo(switchBool: true, titleInfo: "註冊錯誤", messageInfo: "請再次檢查")
                            return
                        }
                        alertInfo(switchBool: true, titleInfo: "", messageInfo: "")
                        print("signUp 成功")
                    }
                }
            }else{
                //檢查若有一個沒輸入找到是哪個沒有輸入跳出相對應警告
                let checkTextFieldArray = [confirmPassword, firstPassword, emailSignUp]
                let alertStringArray = ["請再次輸入密碼","請輸入密碼","請輸入帳號"]
                for i in 0...2 {
                    if checkTextFieldArray[i] == "" {
                        alertInfo(switchBool: true, titleInfo: alertStringArray[i], messageInfo: "請再次檢查")
                    }
                }
            }
        }, label: {
            Text("SignUp")
                .frame(width: 300.0, height: 55)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .background(Color.black)
                .font(.system(size: 30))
                .cornerRadius(10)
                
        })
        .alert(isPresented: $alertIsPresentedToWarn, content: {
            if title != "" {
                print("title\(self.title) message\(self.message)")
                return Alert(title: Text("\(title)"), message: Text("\(message)"), dismissButton: .default(Text("了解"), action: {
                }))
            }else {
                return Alert(title: Text("註冊完成"), message: Text("請至登入頁重新登入"), dismissButton: .default(Text("了解"), action: {
                        do {
                            try Auth.auth().signOut()
                        }catch{
                            print(error)
                        }
                    presentationMode.wrappedValue.dismiss()
                }))
            }

        })
        .padding()
        
        //MARK:返回登入頁按鈕
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Back To SignIn")
                .frame(width: 300.0, height: 55)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .background(Color.gray)
                .font(.system(size: 30))
                .cornerRadius(10)
        })
        
    Spacer()
    }
    
    /// - parameter switchBool: 是否轉true以致跳出警告
    /// - parameter titleInfo: 警告標題
    /// - parameter messageInfo: 警告內文
    func alertInfo(switchBool:Bool, titleInfo:String, messageInfo:String) {
        title = titleInfo
        message = messageInfo
        alertIsPresentedToWarn = switchBool
    }

    
}

//預覽
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

//
//  ContentView.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/28.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore




struct ContentView: View {
    @State private var loginIsFailToSignUp = false          //跳註冊畫面
    @State private var loginIsSuscess = false               //跳登入成功畫面
    @State private var alertIsPresentedToError = false      //跳警告
    @State private var checkError = false                   //跳警告
    @State private var emailAddress = ""                    //email帳號
    @State private var password = ""                        //登入密碼
    @State private var title = ""                           //提示警告title
    @State private var message = ""                         //提示警告message

    
    var body: some View {

        VStack {
            //login text
            Text("LogIn")
                .fontWeight(.bold)
                .font(.system(size: 35))
                .padding()
                .frame(width: 400, height: 100, alignment: .leading)

            VStack {
                //帳號輸入
                TextField("Your Email Address", text: $emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 300, height: 50, alignment: .center)
                    .border(Color.black)
                //密碼輸入
                SecureField("Your Password", text: $password)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 300, height: 50, alignment: .center)
                    .border(Color.black)
                
                //MARK: 登入按鈕
                Button(action: {
                    if emailAddress.isEmpty != true, password.isEmpty != true {
                        if emailAddress.range(of: "@") == nil || emailAddress.range(of: ".") == nil {
                            alertInfo(switchBool: true, titleInfo: "Email格式錯誤", messageInfo: "請確認格式")
                        }else if password.count < 8 {
                            alertInfo(switchBool: true, titleInfo: "密碼長度錯誤", messageInfo: "請確認密碼至少八位數")
                        }else{
                            Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
                                guard result != nil, error == nil else{
                                    alertInfo(switchBool: true, titleInfo: "", messageInfo: "")
                                    return}
                                self.loginIsSuscess = true
                                emailAddress = ""
                                password = ""
                                //print("登入大成功")
                            }
                        }
                    }else{
                        if emailAddress.isEmpty == true {
                            print("email")
                            alertInfo(switchBool: true, titleInfo: "帳號未輸入", messageInfo: "請協助輸入")
                        }else{
                            alertInfo(switchBool: true, titleInfo: "密碼未輸入", messageInfo: "請協助輸入")
                        }
                    }
                    
                }, label: {
                    Text("SignIn")
                        .frame(width: 300.0, height: 55)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .background(Color.black)
                        .font(.system(size: 30))
                        .cornerRadius(10)
      
                })

                .alert(isPresented: $alertIsPresentedToError, content: {
                    if title != "" {
                        print("title\(self.title) message\(self.message)")
                        return Alert(title: Text("\(title)"), message: Text("\(message)"), dismissButton: .default(Text("了解"), action: {
                        }))
                    }else {
                        return Alert(title: Text("登入失敗"), message: Text("密碼錯誤或是未註冊，是否需要新註冊帳號？"), primaryButton: .default(Text("好"), action: {
                            self.loginIsFailToSignUp = true
                        }), secondaryButton: .cancel(Text("重輸密碼")))
                    }
                })
                .fullScreenCover(isPresented: $loginIsSuscess, content: SignInSuscessView.init)
                .fullScreenCover(isPresented: $loginIsFailToSignUp, content: SignUpView.init)
                .padding()
                .padding()
                
                //MARK:註冊按鈕
                Button(action: {
                    loginIsFailToSignUp = true
                }, label: {
                    Text("SignUp")
                    .fullScreenCover(isPresented: $loginIsFailToSignUp, content: SignUpView.init)
                })
            }
        }
        .padding()
        Spacer()
    }
    
    /**
     檢查是否有不符合的地方跳出警告
    */
    /// - parameter switchBool: 是否轉true以致跳出警告
    /// - parameter titleInfo: 警告標題
    /// - parameter messageInfo: 警告內文
    func alertInfo(switchBool:Bool, titleInfo:String, messageInfo:String) {
        title = titleInfo
        message = messageInfo
        alertIsPresentedToError = switchBool
    }
}

//預覽
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




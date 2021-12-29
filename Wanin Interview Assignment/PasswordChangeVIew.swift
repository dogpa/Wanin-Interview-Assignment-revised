//
//  PasswordChangeVIew.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/28.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct PasswordChangeVIew: View {
    @Environment(\.presentationMode) var presentationMode   //返回上一頁
    @State private var firstChangePassword = ""             //第一次新密碼
    @State private var confirmChangePassword = ""           //第二次新密碼
    @State private var title = ""                           //提示警告title
    @State private var message = ""                         //提示警告message
    @State private var changePasswordIncorrect = false      //檢查密碼正確性
    @State private var transformContentView = false         //是否跳到第一頁
    
    var body: some View {
        //Change Password
        Text("Change Password")
            .fontWeight(.bold)
            .font(.system(size: 35))
            .padding()
            .frame(width: 375, height: 100, alignment: .leading)
        //第一次改密碼
        SecureField("Input Password", text: $firstChangePassword)
            .autocapitalization(.none)
            .padding()
            .frame(width: 300, height: 50, alignment: .center)
            .border(Color.black)
        //第二次核對密碼
        SecureField("Confirm Password", text: $confirmChangePassword)
            .autocapitalization(.none)
            .padding()
            .frame(width: 300, height: 50, alignment: .center)
            .border(Color.black)
        //密碼規範text
        Text("密碼規則：\n至少一個英文及數字\n密碼長度至少8字元")
            .frame(width: 350, height: 70, alignment: .center)
            .padding()
        
        //MARK:修改密碼
        Button(action: {
            //檢查變更密碼的正確性
            if firstChangePassword.isEmpty != true,
               confirmChangePassword.isEmpty != true {
                if firstChangePassword.count < 8 || confirmChangePassword.count < 8 {
                    alertInfo(switchBool: true, titleInfo: "密碼長度過短", messageInfo: "密碼需超過八位字元")
                }else if firstChangePassword != confirmChangePassword {
                    alertInfo(switchBool: true, titleInfo: "密碼不一致", messageInfo: "請檢查兩個密碼是否一樣")
                }else if checkPasswordFollowRule(firstChangePassword) == true {
                    alertInfo(switchBool: true, titleInfo: "密碼不符合規定", messageInfo: "請確認密碼規則")
                }else{
                    print(Auth.auth().currentUser?.email)
                    Auth.auth().currentUser?.updatePassword(to: firstChangePassword) { (error) in
                        guard error == nil else {
                            alertInfo(switchBool: true, titleInfo: "修改密碼錯誤", messageInfo: "請再次檢查")
                            return
                        }
                        transformContentView = true
                        alertInfo(switchBool: false, titleInfo: "", messageInfo: "")
                        firstChangePassword = ""
                        confirmChangePassword = ""
                        
                        try? Auth.auth().signOut()
                        

                    }
                }
            }
        }, label: {
            Text("Submit")
                .frame(width: 300.0, height: 55)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .background(Color.black)
                .font(.system(size: 30))
                .cornerRadius(10)
        })

        .fullScreenCover(isPresented: $transformContentView, content: ContentView.init)
        .alert(isPresented: $changePasswordIncorrect, content: {
            if title != "" {
                print("title\(self.title) message\(self.message)")
                return Alert(title: Text("\(title)"), message: Text("\(message)"), dismissButton: .default(Text("了解"), action: {
                }))
            
            }else {
                return Alert(title: Text("密碼變更完成"), message: Text("請記得自己的新密碼謝謝"), dismissButton: .default(Text("了解"), action: {

                    //presentationMode.wrappedValue.dismiss()
                    
                    //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)這個會有紫色警告

                }
                ))
            }
            
        })

        
        Spacer()
    }
    
    /// - parameter switchBool: 是否轉true以致跳出警告
    /// - parameter titleInfo: 警告標題
    /// - parameter messageInfo: 警告內文
    func alertInfo(switchBool:Bool, titleInfo:String, messageInfo:String) {
        title = titleInfo
        message = messageInfo
        changePasswordIncorrect = switchBool
    }
}

//預覽
struct PasswordChangeVIew_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeVIew()
    }
}

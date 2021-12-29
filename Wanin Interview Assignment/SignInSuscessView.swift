//
//  SignInSuscessView.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/28.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore


struct SignInSuscessView: View {
    
    @Environment(\.presentationMode) var presentationMode           //返回上一頁
    @State private var changePassword = false                       //跳改密碼頁的狀態
    @State private var sucessLabel = Auth.auth().currentUser?.email//取得使用者email
   
    var body: some View {
        VStack {
            //hello text
            Text("Hello")
                .fontWeight(.bold)
                .font(.system(size: 35))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding()
                .frame(width: 400, height: 70, alignment: .leading)
            
            //使用者email
            Text("\(sucessLabel ?? "貴賓")")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding()
                .frame(width: 400, height: 70, alignment: .leading)
            
            //MARK:改密碼按鈕
            Button(action: {
                self.changePassword = true
            }, label: {
                Text("Change Password")
                    .frame(width: 300.0, height: 55)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .background(Color.black)
                    .font(.system(size: 30))
                    .cornerRadius(10)
            })
            .fullScreenCover(isPresented: $changePassword, content: PasswordChangeVIew.init)
        }
        
        Spacer()
        
        VStack {
            //MARK:登出返回登入頁按鈕
            Button(action: {
                try? Auth.auth().signOut()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("SignOut")
            })
        }
    }
}

//預覽
struct SignInSuscessView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSuscessView()
    }
}

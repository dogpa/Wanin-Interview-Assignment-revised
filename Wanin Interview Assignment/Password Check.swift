//
//  Password Check.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/29.
//

import Foundation

//檢查後回傳true or false後續判斷使用
func checkPasswordFollowRule (_ string:String) -> Bool {
    var lower = 0
    var number = 0                          //設定三個變數
    let numberString = "0123456789"
    for i in string {
        if numberString.contains(i) {
            number += 1                     //檢查數字
        }else if i.isLowercase{
            lower += 1                      //檢查小寫
        }
    }
    //print(captial,lower,number)
    if lower == 0 || number == 0 {
        return true                         //其中一個為0代表沒有遵從密碼規定回傳true
    }else{
        return false
    }                                       //密碼檢查符合規定回傳false
    
}

//
//  AdyenThreeDS2Wrapper.swift
//  Quarters
//
//  Created by Kenneth Rangel on 06.08.20.
//


let helperSingleton = HelperThreeDS2()

@objc public class AdyenThreeDS2Wrapper: NSObject {
    @objc public func identify(_ token: String?, paymentData: String?) {
        guard let token = token, let  paymentData = paymentData else { return }
        helperSingleton.identify(token, paymentData)
     } 
    @objc public func challenger(_ token: String?, paymentData: String?) {
        guard let token = token, let paymentData = paymentData else { return }
        helperSingleton.challenger(token, paymentData)
     }
}

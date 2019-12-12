import PassKit
import TPDirect

class TPDTransactionResult : NSObject {
    // message, Report Message.
    var message: String!
    
    // status, Result Code, '0' Means Success.
    var status: Int = 0
    
    // amount
    var amount: NSDecimalNumber!
    
    // paymentMehod
    var paymentMethod: PKPaymentMethod!
}

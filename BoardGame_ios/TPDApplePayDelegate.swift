import PassKit
import TPDirect

 protocol TPDApplePayDelegate : NSObjectProtocol {
    // Send To The Delegate After Receive Prime.
    func tpdApplePay(_ applePay: TPDApplePay!, didReceivePrime prime: String!)
    
    // Send To The Delegate After Apple Pay Payment Processing Succeeds.
    func tpdApplePay(_ applePay: TPDApplePay!, didSuccessPayment result: TPDTransactionResult!)
    
    // Send To The Delegate After Apple Pay Payment Processing Fails.
    func tpdApplePay(_ applePay: TPDApplePay!, didFailurePayment result: TPDTransactionResult!)
    
    // Send To The Delegate After Apple Pay Payment's Form Is Shown.
    func tpdApplePayDidStartPayment(_ applePay: TPDApplePay!)
    
    // Send To The Delegate After User Selects A Payment Method.
    // You Can Change The PaymentItem Or Discount Here.
    @available(iOS 9.0, *)
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect paymentMethod: PKPaymentMethod!, cart: TPDCart!) -> TPDCart!
    
    // Send To The Delegate After User Selects A Shipping Method.
    // Set shippingMethods ==> TPDMerchant.shippingMethods.
    @available(iOS 8.0, *)
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect shippingMethod: PKShippingMethod!)
    
    // Send To The Delegate After User Authorizes The Payment.
    // You Can Check Shipping Contact Here, Return YES If Authorized.
    @available(iOS 9.0, *)
    func tpdApplePay(_ applePay: TPDApplePay!, canAuthorizePaymentWithShippingContact shippingContact: PKContact!) -> Bool
    
    // Send To The Delegate After User Cancels The Payment.
    func tpdApplePayDidCancelPayment(_ applePay: TPDApplePay!)
    
    // Send To The Delegate After Apple Pay Payment's Form Disappeared.
    func tpdApplePayDidFinishPayment(_ applePay: TPDApplePay!)
}

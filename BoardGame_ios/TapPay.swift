

import UIKit
import PassKit
import TPDirect

class TapPay: UIViewController {
    
    var merchant : TPDMerchant!
    var consumer : TPDConsumer!
    var cart     : TPDCart!
    var applePay : TPDApplePay!
    var applePayButton : PKPaymentButton!
    @IBOutlet weak var displayText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("version \(TPDSetup.version())")
        merchantSetting()
        consumerSetting()
        cartSetting()
        paymentButtonSetting()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - @IBAction
    @objc func didClickBuyButton(sender:PKPaymentButton) {
        
        applePay = TPDApplePay.setupWthMerchant(merchant, with: consumer, with: cart, withDelegate: self)
        
        applePay.startPayment()
        
    }
    
    
    //MARK: - Apple Pay Setting
    func paymentButtonSetting() {
        // Check Consumer / Application Can Use Apple Pay.
        if (TPDApplePay.canMakePayments(usingNetworks: self.merchant.supportedNetworks)) {
            applePayButton = PKPaymentButton.init(paymentButtonType: .buy, paymentButtonStyle: .black)
        } else {
            applePayButton = PKPaymentButton.init(paymentButtonType: .setUp, paymentButtonStyle: .black)
        }
        
        view.addSubview(applePayButton)
        applePayButton.center = view.center
        
        applePayButton.addTarget(self, action: #selector(TapPay.didClickBuyButton(sender:)), for: .touchUpInside)
    }
    
    
    func merchantSetting() {
        
        merchant = TPDMerchant()
        merchant.merchantName               = "TapPay!"
        merchant.merchantCapability         = .capability3DS;
        merchant.applePayMerchantIdentifier = "merchant.BoardGame"; // Your Apple Pay Merchant ID (https://developer.apple.com/account/ios/identifier/merchant)
        merchant.countryCode                = "TW";
        merchant.currencyCode               = "TWD";
        merchant.acquirerMerchantID         = "a10033135_TAISHIN"
        merchant.supportedNetworks          = [.amex, .masterCard, .visa]

        
        // Set Shipping Method.
        let shipping1 = PKShippingMethod()
        shipping1.identifier = "TapPayExpressShippint024"
        shipping1.detail     = "Ships in 24 hours"
        shipping1.amount     = NSDecimalNumber(string: "10.0");
        shipping1.label      = "Shipping 24"
        
        let shipping2 = PKShippingMethod()
        shipping2.identifier = "TapPayExpressShippint006";
        shipping2.detail     = "Ships in 6 hours";
        shipping2.amount     = NSDecimalNumber(string: "50.0");
        shipping2.label      = "Shipping 6";
        //        merchant.shippingMethods            = [shipping1, shipping2];
        
    }
    
    func consumerSetting() {
        
        // Set Consumer Contact.
        let contact = PKContact()
        var name    = PersonNameComponents()
        let player_id = loadUserDefaults("player")
        name.familyName = player_id
        name.givenName  = player_id
        contact.name    = name;
        
        consumer = TPDConsumer()
        consumer.billingContact     = contact
        consumer.shippingContact    = contact
        consumer.requiredShippingAddressFields  = []
        consumer.requiredBillingAddressFields   = []
        
    }
    
    func cartSetting() {
        cart = TPDCart()
        let point = TPDPaymentItem(itemName: "點數", withAmount: NSDecimalNumber(string: "100.00"), withIsVisible: false)
        cart.add(point)
        
        let point2 = TPDPaymentItem(itemName: "點數", withAmount: NSDecimalNumber(string: "300.00"), withIsVisible: false)
        cart.add(point2)
        
        let point3 = TPDPaymentItem(itemName: "點數", withAmount: NSDecimalNumber(string: "500.00"), withIsVisible: false)
        cart.add(point3)
    }
    
}


extension TapPay :TPDApplePayDelegate {
    
    func tpdApplePayDidStartPayment(_ applePay: TPDApplePay!) {
        //
        print("=====================================================")
        print("Apple Pay On Start")
        print("===================================================== \n\n")
    }
    
    func tpdApplePay(_ applePay: TPDApplePay!, didSuccessPayment result: TPDTransactionResult!) {
        //
        print("=====================================================")
        print("Apple Pay Did Success ==> Amount : \(result.amount.stringValue)")
        
        print("shippingContact.name : \(String(describing: applePay.consumer.shippingContact?.name?.givenName)) \( String(describing: applePay.consumer.shippingContact?.name?.familyName))")
        print("shippingContact.emailAddress : \(String(describing: applePay.consumer.shippingContact?.emailAddress))")
        print("shippingContact.phoneNumber : \(String(describing: applePay.consumer.shippingContact?.phoneNumber?.stringValue))")
        
        
        print("===================================================== \n\n")
        
        
    }
    
    func tpdApplePay(_ applePay: TPDApplePay!, didFailurePayment result: TPDTransactionResult!) {
        //
        print("=====================================================")
        print("Apple Pay Did Failure ==> Message : \(String(describing: result.message)), ErrorCode : \(result.status)")
        print("===================================================== \n\n")
    }
    
    func tpdApplePayDidCancelPayment(_ applePay: TPDApplePay!) {
        //
        print("=====================================================")
        print("Apple Pay Did Cancel")
        print("===================================================== \n\n")
    }
    
    func tpdApplePayDidFinishPayment(_ applePay: TPDApplePay!) {
        //
        print("=====================================================")
        print("Apple Pay Did Finish")
        print("===================================================== \n\n")
    }
    
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect shippingMethod: PKShippingMethod!) {
        //
        print("=====================================================")
        print("======> didSelectShippingMethod: ")
        print("Shipping Method.identifier : \(String(describing: shippingMethod.identifier?.description))")
        print("Shipping Method.detail : \(String(describing: shippingMethod.detail))")
        print("===================================================== \n\n")
    }
    
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect paymentMethod: PKPaymentMethod!, cart: TPDCart!) -> TPDCart! {
        //
        print("=====================================================");
        print("======> didSelectPaymentMethod: ");
        print("===================================================== \n\n");
        
        if paymentMethod.type == .debit {
            self.cart.add(TPDPaymentItem(itemName: "Discount", withAmount: NSDecimalNumber(string: "-1.00")))
        }
        
        return self.cart;
        
    }
    func tpdApplePay(_ applePay: TPDApplePay!, canAuthorizePaymentWithShippingContact shippingContact: PKContact!) -> Bool {
        
        print("=====================================================")
        print("======> canAuthorizePaymentWithShippingContact ")
        print("shippingContact.name : \(String(describing: shippingContact?.name?.givenName)) \(String(describing: shippingContact?.name?.familyName))")
        print("shippingContact.emailAddress : \(String(describing: shippingContact?.emailAddress))")
        print("shippingContact.phoneNumber : \(String(describing: shippingContact?.phoneNumber?.stringValue))")
        print("===================================================== \n\n")
        return true;
    }
    
    // With Payment Handle
    func tpdApplePay(_ applePay: TPDApplePay!, didReceivePrime prime: String!) {
        
        // 1. Send Your Prime To Your Server, And Handle Payment With Result
        // ...
        print("=====================================================");
        print("======> didReceivePrime");
        print("Prime : \(prime!)");
        print("total Amount :   \(applePay.cart.totalAmount!)")
        print("Client IP : \(applePay.consumer.clientIP!)")
        print("shippingContact.name : \(String(describing: applePay.consumer.shippingContact?.name?.givenName)) \(String(describing: applePay.consumer.shippingContact?.name?.familyName))");
        print("shippingContact.emailAddress : \(String(describing: applePay.consumer.shippingContact?.emailAddress))");
        print("shippingContact.phoneNumber : \(String(describing: applePay.consumer.shippingContact?.phoneNumber?.stringValue))");
        print("===================================================== \n\n");
        
        
        DispatchQueue.main.async {
            let payment = "Use below cURL to proceed the payment.\ncurl -X POST \\\nhttps://sandbox.tappaysdk.com/tpc/payment/pay-by-prime \\\n-H \'content-type: application/json\' \\\n-H \'x-api-key: partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\' \\\n-d \'{ \n \"prime\": \"\(prime!)\", \"partner_key\": \"partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\", \"merchant_id\": \"GlobalTesting_CTBC\", \"details\":\"TapPay Test\", \"amount\": \(applePay.cart.totalAmount!.stringValue), \"cardholder\": { \"phone_number\": \"+886923456789\", \"name\": \"Jane Doe\", \"email\": \"Jane@Doe.com\", \"zip_code\": \"12345\", \"address\": \"123 1st Avenue, City, Country\", \"national_id\": \"A123456789\" }, \"remember\": true }\'"
            self.displayText.text = payment
            print(payment)
            
        }
        
        // 2. If Payment Success, set paymentReault = ture.
        let paymentReault = true;
        applePay.showPaymentResult(paymentReault)
    }
    
    fileprivate func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{ return }
                print("data = ", data)//可以執行到此處印出 data 容量
                completion(data)
            }
        }
        task.resume()
    }
}

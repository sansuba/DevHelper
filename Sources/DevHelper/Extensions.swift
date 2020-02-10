// Extensions.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import UIKit

extension Bool: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Float: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Int: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension Int32: JSONEncodable {
    func encodeToJSON() -> Any { return NSNumber(value: self as Int32) }
}

extension Int64: JSONEncodable {
    func encodeToJSON() -> Any { return NSNumber(value: self as Int64) }
}

extension Double: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

extension String: JSONEncodable {
    func encodeToJSON() -> Any { return self as Any }
}

private func encodeIfPossible<T>(_ object: T) -> Any {
    if let encodableObject = object as? JSONEncodable {
        return encodableObject.encodeToJSON()
    } else {
        return object as Any
    }
}

extension Array: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.map(encodeIfPossible)
    }
}

extension Dictionary: JSONEncodable {
    func encodeToJSON() -> Any {
        var dictionary = [AnyHashable: Any]()
        for (key, value) in self {
            dictionary[key] = encodeIfPossible(value)
        }
        return dictionary as Any
    }
}

extension Data: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.base64EncodedString(options: Data.Base64EncodingOptions())
    }
}

private let dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = Configuration.dateFormat
    fmt.locale = Locale(identifier: "en_US_POSIX")
    return fmt
}()

extension Date: JSONEncodable {
    func encodeToJSON() -> Any {
        return dateFormatter.string(from: self) as Any
    }
}

extension UUID: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.uuidString
    }
}

extension String: CodingKey {

    public var stringValue: String {
        return self
    }

    public init?(stringValue: String) {
        self.init(stringLiteral: stringValue)
    }

    public var intValue: Int? {
        return nil
    }

    public init?(intValue: Int) {
        return nil
    }

}

extension KeyedEncodingContainerProtocol {

    public mutating func encodeArray<T>(_ values: [T], forKey key: Self.Key) throws where T : Encodable {
        var arrayContainer = nestedUnkeyedContainer(forKey: key)
        try arrayContainer.encode(contentsOf: values)
    }

    public mutating func encodeArrayIfPresent<T>(_ values: [T]?, forKey key: Self.Key) throws where T : Encodable {
        if let values = values {
            try encodeArray(values, forKey: key)
        }
    }

    public mutating func encodeMap<T>(_ pairs: [Self.Key: T]) throws where T : Encodable {
        for (key, value) in pairs {
            try encode(value, forKey: key)
        }
    }

    public mutating func encodeMapIfPresent<T>(_ pairs: [Self.Key: T]?) throws where T : Encodable {
        if let pairs = pairs {
            try encodeMap(pairs)
        }
    }

}

extension KeyedDecodingContainerProtocol {

    public func decodeArray<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T] where T : Decodable {
        var tmpArray = [T]()

        var nestedContainer = try nestedUnkeyedContainer(forKey: key)
        while !nestedContainer.isAtEnd {
            let arrayValue = try nestedContainer.decode(T.self)
            tmpArray.append(arrayValue)
        }

        return tmpArray
    }

    public func decodeArrayIfPresent<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T]? where T : Decodable {
        var tmpArray: [T]? = nil

        if contains(key) {
            tmpArray = try decodeArray(T.self, forKey: key)
        }

        return tmpArray
    }

    public func decodeMap<T>(_ type: T.Type, excludedKeys: Set<Self.Key>) throws -> [Self.Key: T] where T : Decodable {
        var map: [Self.Key : T] = [:]

        for key in allKeys {
            if !excludedKeys.contains(key) {
                let value = try decode(T.self, forKey: key)
                map[key] = value
            }
        }

        return map
    }

}

//REf: https://stackoverflow.com/a/47246424
extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
    }
}

extension UIViewController {
    func alertOk(title: String = "Alert_Title_Error", message: String, _ completion: (()->())? = nil) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Alert_Button_OK".localized, style: .cancel, handler: { (_) in
            completion?()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, buttons:[String] = ["Yes", "No"], _ success: @escaping (_ success: Bool)->()) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: buttons[0], style: .default, handler: { (_) in
            success(true)
        })
        let noAction = UIAlertAction(title: buttons[1], style: .cancel, handler: { (_) in
            success(false)
        })
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func singleAlert(title: String, message: String, button:String = "Yes", _ success: @escaping (_ success: Bool)->()) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: button, style: .default, handler: { (_) in
            success(true)
        })
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var noConnection: Bool {
        get {
            if NetworkReachabilityManager()?.isReachable == false {
                self.alertNoConnection()
                return true
            }
            return false
        }
    }
    
    func alertNoConnection(title: String = "Alert_Title_Error", message: String = "No_internet_connection", _ completion: (()->())? = nil) {
        self.alertOk(message: message)
    }
    
    func showNetworkActivity(Indicator: Bool) {
        if Indicator {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    
}

extension String {
    
    var localized :String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func replaceWith(pair: [String: String]) -> String {
        var text = self
        for key in pair.keys {
            let keyStr = String(key)
            let value = pair[keyStr] ?? ""
            text = text.replacingOccurrences(of: keyStr, with: value)
        }
        return text
    }
}

enum Cache :String {
    case account
    case facility
    case appupdate
    case loginsession
    case screentimeout
    case deviceId
    case facilityId
    case deviceToken
    
    static var clear: Void {
        [Cache.account, Cache.appupdate, Cache.loginsession].forEach { (cache) in
            cache.clear
        }
        return
    }
}

extension Cache {
    func toData<T: Encodable>(object: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(object)
    }
    
    func save<T :Encodable>(_ type: T.Type, from data: T) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: self.rawValue)
        } else {
            UserDefaults.standard.set(data, forKey: self.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    func read<T :Decodable>(_ type: T.Type) -> T? {
        if let userData = UserDefaults.standard.data(forKey: self.rawValue), let object = try? JSONDecoder().decode(T.self, from: userData) {
            return object
        } else if let value = UserDefaults.standard.value(forKey: self.rawValue) {
            return value as? T
        } else {
            return nil
        }
    }
    
    var clear :Void {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
        UserDefaults.standard.synchronize()
        return
    }
}

extension String {
    
    var isValidEmail: Bool {
        
        get {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
        
        
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    var setRedBorders: Void {
        let myColor = UIColor.red
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.25
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    var setDefaultBorders: Void {
        let myColor = UIColor.lightGray
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.25
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

typealias TextEditClosure = ((_ text: String) -> Void)

class FieldSpecifier {
    var specifiers = [UITextField : (prefix :String, suffix :String)]()
    var fields = [UITextField : (min :Int, max :Int)]()
    
    var textChanged: [UITextField: TextEditClosure?] = [:]
    
    static let `shared` = FieldSpecifier()
    
    func add(field :UITextField, limits :(min :Int , max :Int)) {
        FieldSpecifier.shared.fields[field] = limits
    }
    
    func valid(field :UITextField) -> Bool {
        guard let (min, max) = FieldSpecifier.shared.fields[field] else {
            return true
        }
        
        guard let text = field.text else {
            return true
        }
        
        return !(!(text.count < min) || !(text.count > max))
    }
    
    func validString(field :UITextField) -> String {
        guard let text = field.text, let limits = FieldSpecifier.shared.fields[field] else {
            return ""
        }
        
        if text.count > limits.max {
            return text.substring(to: text.index(text.startIndex, offsetBy: limits.max))
        }
        return text
    }
    
}

extension UITextField {
    func length(minmax :[Int]) -> UITextField? {
        FieldSpecifier.shared.add(field: self, limits: (min: minmax.first ?? 0, max: minmax.last ?? 25))
        self.addTarget(self, action: #selector(textDidChange), for:.editingChanged)
        self.addTarget(self, action: #selector(textEndChange), for:.editingDidEnd)
        self.addTarget(self, action: #selector(textBeginChange), for:.editingDidBegin)
        return self
    }
    
    var release :Void {
        self.removeTarget(self, action: #selector(textEndChange), for: .allEditingEvents)
        FieldSpecifier.shared.specifiers[self] = nil
        FieldSpecifier.shared.fields[self] = nil
        FieldSpecifier.shared.textChanged.removeValue(forKey: self)
    }
    
    func specifier(pre :String? = "", suff :String? = "") {
        FieldSpecifier.shared.specifiers[self] = (pre ?? "", suff ?? "")
    }
    
    @objc func textDidChange() {
        if !FieldSpecifier.shared.valid(field: self) {
            self.text = FieldSpecifier.shared.validString(field: self)
        }
        
        if let actioner = FieldSpecifier.shared.textChanged[self] {
            actioner?(self.text ?? "")
        }
    }
    
    func textEdited(_ completion: @escaping TextEditClosure) {
        FieldSpecifier.shared.textChanged[self] = completion
    }
    
    @objc func textBeginChange() {
        let spec = FieldSpecifier.shared.specifiers[self]
        if let prefix = spec?.prefix, let txt = self.text, txt.hasPrefix(prefix) == true {
            self.text = txt.replacingOccurrences(of: prefix, with: "")
        }
        
        if let suffix = spec?.suffix, let txt = self.text, txt.hasSuffix(suffix) == true  {
            self.text = txt.replacingOccurrences(of: suffix, with: "")
        }
    }
    
    @objc func textEndChange() {
        let spec = FieldSpecifier.shared.specifiers[self]
        if let prefix = spec?.prefix, let txt = self.text {
            self.text = prefix + txt
        }
        
        if let suffix = spec?.suffix, let txt = self.text {
            self.text = txt + suffix
        }
    }
}

extension Error {
    func code(_ code: Int) -> Bool {
        if let err = self as? ErrorResponse {
            switch(err) {
            case .error(code, _, _): return true;
            case .error(_, _, _):
                return false
            default:
                return false
            }
        }
        return false
    }
    
    var code: Int {
        guard let err = self as? ErrorResponse
            else { return (self as NSError).code }
        
        switch err{
        case ErrorResponse.error(let code, _, _):
            return code
        }
    }
    
}

typealias SelectionClosure = (_ indexPath :IndexPath)->Void
typealias SelectionItemClosure = (_ item :AnyObject)->Void
typealias CellUpdateClosure = (_ indexPath :IndexPath,_ cell: UITableViewCell)->Void

class QuickTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var selectionClosure: SelectionClosure? = nil
    var cellUpdateClosure: CellUpdateClosure? = nil
    var selectionItemClosure: SelectionItemClosure? = nil
    var cellHeight: CGFloat = 44
    var nofItems: [AnyObject] = [] {
        didSet {
            self.reloadData()
            
            DispatchQueue.main.async {
                if self.nofItems.count > 0 {
                    self.isHidden = false
                } else {
                    self.isHidden = true
                }
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.plain)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
    }
    
    func configWithClosures<T>(items: [T], _ selectionCls: @escaping SelectionClosure, cellUpdateCls: @escaping CellUpdateClosure) {
        nofItems = items as [AnyObject]
        self.delegate = self
        self.dataSource = self
        self.cellUpdateClosure = cellUpdateCls
        self.selectionClosure = selectionCls
    }
    
    func cellUpdateClosure(_ cellUpdateCls: @escaping CellUpdateClosure) {
        self.cellUpdateClosure = cellUpdateCls
    }
    
    func configWithItems<T>(items: [T]) {
        if self.delegate == nil {
            self.delegate = self
            self.dataSource = self
        }
        nofItems = items as [AnyObject]
        self.reloadData()
    }
    
    func actionWithSelection(_ selection: @escaping SelectionItemClosure) {
        selectionItemClosure = selection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nofItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        self.cellUpdateClosure?(indexPath, cell)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionClosure?(indexPath)
        self.selectionItemClosure?(nofItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight == 0 ? UITableView.automaticDimension : cellHeight
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //0xFFFFFF
    convenience init(hexCode:Int) {
        self.init(red:(hexCode >> 16) & 0xff, green:(hexCode >> 8) & 0xff, blue:hexCode & 0xff)
    }
    
    func fromHex(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(hexCode: Int(rgbValue))
    }
    
    //0xFFFFFF7D
    static func color(hexCode:Int64) -> UIColor {
        let cred = (hexCode >> 24) & 0xff
        let cgreen = (hexCode >> 16) & 0xff
        let cblue = (hexCode >> 8) & 0xff
        let calpha = hexCode & 0xff
        
        assert(cred >= 0 && cred <= 255, "Invalid red component")
        assert(cgreen >= 0 && cgreen <= 255, "Invalid green component")
        assert(cblue >= 0 && cblue <= 255, "Invalid blue component")
        assert(calpha >= 0 && calpha <= 255, "Invalid alpha component")
        
        return UIColor(red: CGFloat(cred) / 255.0, green: CGFloat(cgreen) / 255.0, blue: CGFloat(cblue) / 255.0, alpha: CGFloat(calpha) / 255.0)
    }
    
    class var deepSkyBlue: UIColor {
        return UIColor(red: 0.00, green: 0.69, blue: 0.92, alpha: 1.00)
    }
    
    class var tosPopupTextColor: UIColor {
        return UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
    }
}

extension String {
    func formattedPhoneNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedUSPhoneNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var dateWithTimeZone :Date {
        get {
            return DateFormatter.date(from: self)
        }
    }
}

extension Date {
    var startOfNextDay: Date {
        return Calendar.current.nextDate(after: self, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!
    }
    var secondsUntilTheNextDay: TimeInterval {
        return startOfNextDay.timeIntervalSince(self)
    }
    
    func formattedStringFromDate5() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d,yyyy"
        return dateFormatter.string(from: self)
    }
    
    ///"Thursday, December 25, 2014"
    func formattedStringFromDate4() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        return dateFormatter.string(from: self)
    }
    
    var zeroCurrentDate :String {
        get {
            return formattedDate(.yyyyMMddTHHmmssZ, isZeroGMT: true)
        }
    }
    
    var localCurrentDate :String {
        get {
            return formattedDate(.yyyyMMddTHHmmssZ, isZeroGMT: false)
        }
    }
    
    func formattedDate(_ format :DateType, isZeroGMT :Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        if isZeroGMT == true {
//            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    
    func setFormat(text :String) {
        if text.count == 10 {
            if let year = text.components(separatedBy: "-").first, year.count == 4 {
                self.dateFormat = "yyyy-MM-dd"
            } else {
                self.dateFormat = "dd-MM-yyyy"
            }
        } else if text.count == 19 {
            if let year = text.components(separatedBy: "-").first, year.count == 4 {
                self.dateFormat = "yyyy-MM-dd HH:mm:ss"
            } else {
                self.dateFormat = "dd-MM-yyyy HH:mm:ss"
            }
        } else if text.contains("T") {
            self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        }
    }
    
    convenience init(text :String) {
        self.init()
        setFormat(text: text)
    }
    
    class func date(from string: String) -> Date {
        return DateFormatter(text: string).date(from: string) ?? Date()
    }
    
    class func string(from style: String, date :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style
        return formatter.string(from: date)
    }
}

enum DateType :String {
    case yyyy = "yyyy"
    case ddMMyyyyHHmmss = "dd/MM/yyyy HH:mm:ss"
    case ddMMyyyyHHmm = "dd/MM/yyyy HH:mm"
    case ddMMyyyyHHmmA = "MM/dd/yyyy hh:mm a"
    case hhmmAddmmyyyy = "hh:mm a, dd/MM/yyyy"
    case hhmmAmmddyyyy = "hh:mm a, MM/dd/yyyy"
    case hhmmss = "HH:mm:ss"
    case hhmm = "HH:mm"
    case hhmma = "hh:mm a"
    case eeeddMMM = "EEE dd MMM"
    case mmmddyyyy = "MMM dd, yyyy"
    case mmddyyyy = "MM/dd/YYYY"
    case ddmmyyyy = "dd/MM/YYYY"
    case ddMMMMyyyy = "dd MMMM yyyy"
    case eeeeddMMMM = "EEEE, dd MMMM"
    case eeeddMMMMyyyy = "EEE dd MMMM, yyyy"
    case eeeeathhmma = "EEEE hh:mm a"
    case eeeeddMMMMyyyy = "EEEE dd MMMM, yyyy"
    case eeeeddMMHHmm = "EEEE, dd MMMM '-' HH':'mm"
    case yyyyMMddHHmmss = "yyyy'-'MM'-'dd HH':'mm':'ss"
    case yyyyMMdd = "yyyy-MM-dd"
    case eeeeddMMMMyyyyHHmm = "EEEE, dd MMMM yyyy - HH':'mm"
    case yyyyMMddTHHmmssZ = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    case osiFormatted = "osi"
    case eeedd = "EEE dd"
}

extension NSAttributedString {
    
    convenience init(htmlString html: String) throws {
        try self.init(data: Data(html.utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
    }
    
}

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        self.attributedText = attrStr
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}

extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substr(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

class WebServiceAPI {
    class func requestFormData(parameters: [String: Any], url: String, completionProgress: ((_ progress: Progress)-> Void)?, completion: @escaping ((Any)->()), failure: ((Any)->())? = nil) {
        //        let parameters = ["upload_preset": "rt8cuu9q", "folder": "newsfeed", "public_id": "1571900116.7384682_5d1b1a6945c2a1002895f9e5"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            //            multipartFormData.append(data, withName: "file",fileName: "1571900116.7384682_5d1b1a6945c2a1002895f9e5", mimeType: "image/jpg")
            for (key, value) in parameters {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: "file", fileName: key, mimeType: "image/jpg")
                } else {
                    if let val = value as? String {
                        multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }
        }, to:url) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    completionProgress?(progress)
                })
                
                upload.responseJSON { response in
                    completion(response.result.value ?? ["":""])
                }
            case .failure(let encodingError):
                failure?(encodingError)
                //                completion(false)
            }
        }
    }
}
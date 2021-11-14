//
//  LaunchSetting.swift
//  ElevatorManagementSystem
//
//  Created by liumingfei on 2021/11/6.
//

import Foundation

class EMLanguageSetting: NSObject {
	
	fileprivate static let kLauguageSettingKey = "LauguageSettingKey"
	
	static let shared: EMLanguageSetting = {
		let languageSetting: EMLanguageSetting
		
		if let cacheData = EMUserDefault.object(forKey: kLauguageSettingKey) as? Data, let defaultSettings = try? NSKeyedUnarchiver.unarchiveObject(with: cacheData) as? EMLanguageSetting {
			languageSetting = defaultSettings
		} else {
			languageSetting = EMLanguageSetting()
		}
		return languageSetting;
	}()
	
	static func saveLanguageSetting() {
		let data = NSKeyedArchiver.archivedData(withRootObject: EMLanguageSetting.shared);
		EMUserDefault.set(data, forKey: kLauguageSettingKey)
	}
	
	enum Language: String {
		case Chinese = "zh-Hans"
		case English = "en"
		var code: String {
			return rawValue
		}
	}
	
	static func localIsCh() -> Bool {
		if let language = Locale.preferredLanguages.first {
			if language.hasPrefix("zh") {
				return true
			}
		}
		return false
	}
	
	let observableLaunguage: EMObservable<Language>

	var language: Language {
		get {
			return observableLaunguage.value
		}
		set {
			observableLaunguage.value = newValue
		}
	}
	override init() {
		let language:Language = .Chinese
		observableLaunguage = EMObservable(language)
		super.init()
	}
	
}

private var bundleByLanguageCode: [String: Foundation.Bundle] = [:]
extension EMLanguageSetting.Language {
	var bundle: Foundation.Bundle? {
		if let bundle = bundleByLanguageCode[code] {
			return bundle
		} else {
			let mainBundle = Foundation.Bundle.main
			if let path = mainBundle.path(forResource: code, ofType: "lproj"),
			   let bundle = Foundation.Bundle(path: path) {
				bundleByLanguageCode[code] = bundle
				return bundle;
			} else {
				return nil
			}
		}
	}
}

class EMBundle: Foundation.Bundle {
	override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
		if let bundle = EMLanguageSetting.shared.language.bundle {
			return bundle.localizedString(forKey: key, value: value, table: tableName)
		} else {
			return super.localizedString(forKey: key, value: value, table: tableName)
		}
	}
}

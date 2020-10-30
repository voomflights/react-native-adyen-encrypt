# react-native-adyen-encrypt

## Getting started

### iOS

1. Install package with `$ npm install react-native-adyen-encrypt --save`
2. modify `ios/Podfile` so that `platform :ios` is >= 10
3. your iOS project will need to have a Swift bridging header. Easiest way to do this is to add a swift file to the project. This file must remain in the project 😢
4. Verify that your SWIFT_VERSION is >= 5
5. `pod install`

iOS uses [Adyen](https://github.com/Adyen/adyen-ios) SDK version 3.6.0

### Android

1. Install package with `$ npm install react-native-adyen-encrypt --save`
2. That should be it 😅

Android uses [Adyen](https://github.com/Adyen/adyen-android) SDK version 3.6.5

## Usage

### Example App

https://github.com/voomflights/react-native-adyen-encrypt-example

### Code Snippet

```javascript
import {AdyenEncryptor, CardForm} from 'react-native-adyen-encrypt'

const cardForm: CardForm = {
  cardNumber: "654654654654654",
  securityCode: "999",
  expiryMonth: "13",
  expiryYear: "1999" // note 4 digit year
}
const encryptor = new AdyenEncryptor(ADYEN_PUBLIC_KEY)
const promise = encryptor.encryptCard(cardForm)
promise.then((data: EncryptedCard) => {
  // do something neat
})
```

# react-native-adyen

## Getting started

### iOS

1. Install package with `$ npm install react-native-adyen --save`
2. modify `ios/Podfile` so that `platform :ios` is >= 10
3. your iOS project will need to have a Swift bridging header. Easiest way to do this is to add a swift file to the project. This file must remain in the project 😢
4. Verify that your SWIFT_VERSION is >= 5
5. `pod install`

### Android

1. Install package with `$ npm install react-native-adyen --save`
2. That should be it 😅

## Usage

### Example App

https://github.com/voomflights/react-native-adyen-example

### Code Snippet

```javascript
let cardForm = {
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

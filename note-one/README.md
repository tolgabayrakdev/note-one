# Note One - iOS SwiftUI Uygulaması

SwiftUI ile geliştirilmiş basit bir not alma uygulaması. Backend API ile entegre çalışır.

## Özellikler

- ✅ Kullanıcı kayıt ve giriş
- ✅ JWT token tabanlı authentication
- ✅ Notlar için CRUD işlemleri
- ✅ Modern SwiftUI arayüzü
- ✅ Pull-to-refresh desteği
- ✅ Swipe-to-delete desteği

## Kurulum

### 1. Backend'i Başlatın

Backend klasörüne gidin ve sunucuyu başlatın:

```bash
cd ../backend
npm install
npm start
```

Backend'in `http://localhost:3000` adresinde çalıştığından emin olun.

### 2. API URL'ini Yapılandırın

**Simulator için:**
`APIService.swift` dosyasındaki `baseURL` değişkeni zaten `http://localhost:3000/api` olarak ayarlanmıştır.

**Gerçek Cihaz için:**
1. Mac'inizin yerel IP adresini öğrenin (System Preferences > Network)
2. `APIService.swift` dosyasını açın
3. `baseURL` değişkenini şu şekilde güncelleyin:
   ```swift
   private let baseURL = "http://YOUR_IP_ADDRESS:3000/api"
   ```
   Örnek: `http://192.168.1.100:3000/api`

### 3. Xcode'da Projeyi Açın

1. `note-one.xcodeproj` dosyasını Xcode ile açın
2. Info.plist dosyasının projeye eklendiğinden emin olun (Xcode'da proje ayarlarından kontrol edin)
3. Simulator veya gerçek cihaz seçin
4. Run (⌘R) tuşuna basarak uygulamayı çalıştırın

## Proje Yapısı

```
note-one/
├── Models/
│   ├── User.swift          # Kullanıcı modeli ve auth request/response modelleri
│   └── Note.swift          # Not modeli
├── Services/
│   ├── APIService.swift    # Backend API ile iletişim
│   └── TokenManager.swift  # JWT token yönetimi
├── ViewModels/
│   ├── AuthViewModel.swift # Authentication state yönetimi
│   └── NotesViewModel.swift # Notes state yönetimi
├── Views/
│   ├── LoginView.swift     # Giriş ekranı
│   ├── RegisterView.swift  # Kayıt ekranı
│   ├── NotesListView.swift # Not listesi
│   └── NoteDetailView.swift # Not detay/oluşturma/düzenleme
├── ContentView.swift       # Ana view (routing)
└── note_oneApp.swift       # App entry point
```

## Kullanım

1. **İlk Kullanım:**
   - Uygulamayı açtığınızda giriş ekranı görünür
   - "Hesabınız yok mu? Kayıt olun" butonuna tıklayarak yeni hesap oluşturun

2. **Not Oluşturma:**
   - Giriş yaptıktan sonra sağ üstteki `+` butonuna tıklayın
   - Başlık ve içerik girin
   - "Kaydet" butonuna tıklayın

3. **Not Düzenleme:**
   - Listeden bir nota tıklayın
   - İçeriği düzenleyin
   - "Kaydet" butonuna tıklayın

4. **Not Silme:**
   - Listeden bir notu sola kaydırın
   - "Delete" butonuna tıklayın

5. **Çıkış Yapma:**
   - Sol üstteki "Çıkış" butonuna tıklayın

## Notlar

- **Network Security:** Info.plist dosyasında `NSAppTransportSecurity` ayarları yapılmıştır. Production ortamında HTTPS kullanmanız önerilir.
- **Token Storage:** JWT token'lar UserDefaults'ta saklanır. Production'da Keychain kullanımı önerilir.
- **Error Handling:** API hataları kullanıcıya gösterilir.

## Gereksinimler

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+
- Backend API çalışıyor olmalı


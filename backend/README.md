# Note API Backend

Node.js Express ve SQLite kullanılarak geliştirilmiş basit bir not alma uygulaması backend'i.

## Özellikler

- Kullanıcı kayıt (Register)
- Kullanıcı giriş (Login)
- JWT token tabanlı authentication
- Notlar için CRUD işlemleri (Create, Read, Update, Delete)
- SQLite veritabanı

## Kurulum

1. Bağımlılıkları yükleyin:
```bash
npm install
```

2. `.env` dosyası oluşturun (`.env.example` dosyasını referans alarak):
```bash
PORT=3000
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d
```

3. Sunucuyu başlatın:
```bash
npm start
```

veya development modunda (auto-reload):
```bash
npm run dev
```

## API Endpoints

### Authentication

#### Register
```
POST /api/auth/register
Body: {
  "username": "kullaniciadi",
  "email": "email@example.com",
  "password": "sifre123"
}
```

#### Login
```
POST /api/auth/login
Body: {
  "email": "email@example.com",
  "password": "sifre123"
}
```

### Notes (Authentication gerekli)

Tüm note endpoint'leri için `Authorization: Bearer <token>` header'ı gereklidir.

#### Tüm notları getir
```
GET /api/notes
Headers: {
  "Authorization": "Bearer <token>"
}
```

#### Tek bir notu getir
```
GET /api/notes/:id
Headers: {
  "Authorization": "Bearer <token>"
}
```

#### Yeni not oluştur
```
POST /api/notes
Headers: {
  "Authorization": "Bearer <token>"
}
Body: {
  "title": "Not Başlığı",
  "content": "Not içeriği"
}
```

#### Notu güncelle
```
PUT /api/notes/:id
Headers: {
  "Authorization": "Bearer <token>"
}
Body: {
  "title": "Güncellenmiş Başlık",
  "content": "Güncellenmiş içerik"
}
```

#### Notu sil
```
DELETE /api/notes/:id
Headers: {
  "Authorization": "Bearer <token>"
}
```

## Veritabanı

SQLite veritabanı otomatik olarak `notes.db` dosyası olarak oluşturulur. İki tablo içerir:

- `users`: Kullanıcı bilgileri
- `notes`: Notlar


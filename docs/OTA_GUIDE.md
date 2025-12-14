# 🚀 OTA Update Guide - Expo React Native

Hướng dẫn đầy đủ về cấu hình và sử dụng OTA (Over-The-Air) Updates với Expo và CI/CD trên GitHub.

## 📋 Mục lục

- [Giới thiệu](#giới-thiệu)
- [Yêu cầu](#yêu-cầu)
- [Cấu hình đã thực hiện](#cấu-hình-đã-thực-hiện)
- [Cách hoạt động](#cách-hoạt-động)
- [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

## 🎯 Giới thiệu

OTA Updates cho phép bạn deploy các thay đổi JavaScript, TypeScript, assets (images, fonts) trực tiếp đến người dùng mà không cần rebuild app hoặc resubmit lên App Store/Play Store.

### ✅ **Điều có thể update qua OTA:**
- JavaScript/TypeScript code
- React components
- Business logic
- Images, fonts, assets
- Styling & UI

### ❌ **Điều KHÔNG thể update qua OTA:**
- Native code (Java, Kotlin, Objective-C, Swift)
- Native dependencies mới
- Permissions mới
- App configuration trong AndroidManifest.xml hoặc Info.plist

## 📦 Yêu cầu

- Node.js >= 18.x
- Expo SDK >= 50.x
- EAS CLI
- Expo account
- GitHub account

## ⚙️ Cấu hình đã thực hiện

### 1. **eas.json** - Cấu hình build & update profiles

```json
{
  "cli": {
    "version": ">= 13.2.3"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "channel": "development"
    },
    "preview": {
      "distribution": "internal",
      "channel": "preview"
    },
    "production": {
      "channel": "production"
    }
  },
  "update": {
    "development": {
      "channel": "development"
    },
    "preview": {
      "channel": "preview"
    },
    "production": {
      "channel": "production"
    }
  }
}
```

### 2. **app.json** - Runtime version & updates config

```json
{
  "expo": {
    "runtimeVersion": {
      "policy": "sdkVersion"
    },
    "updates": {
      "url": "https://u.expo.dev/786c8988-cb81-40ea-b91a-afb92b812194"
    }
  }
}
```

**Runtime Version Policy:**
- `sdkVersion`: Updates chỉ apply cho apps cùng Expo SDK version
- `appVersion`: Updates apply theo version trong package.json
- Custom: Tự định nghĩa logic versioning

### 3. **GitHub Secrets**

Đã cấu hình `EXPO_TOKEN` trong GitHub repository settings:
- Settings → Secrets and variables → Actions → New repository secret
- Name: `EXPO_TOKEN`
- Value: Token từ `eas login` hoặc từ Expo dashboard

### 4. **GitHub Actions Workflows**

#### **ota-update.yml** - Tự động deploy OTA updates

**Triggers:**
- Push lên `main` branch → Deploy to **production** channel
- Push lên `develop` branch → Deploy to **preview** channel
- Manual dispatch → Chọn channel tùy ý

#### **eas-build.yml** - Build app binary

**Triggers:**
- Manual dispatch only
- Chọn platform (Android/iOS/All) và profile

## 🔄 Cách hoạt động

### **Workflow tự động:**

```
1. Developer push code lên GitHub
   ↓
2. GitHub Actions detect branch
   ↓
3. Determine channel:
   - main → production
   - develop → preview
   - other → development
   ↓
4. Run EAS Update
   ↓
5. Publish to Expo CDN
   ↓
6. Users open app → Check for updates → Download & apply
```

### **Update Channels:**

- **development**: Cho testing nội bộ, unstable
- **preview**: Beta testing, QA
- **production**: Production users, stable

## 📖 Hướng dẫn sử dụng

### **1. Setup lần đầu**

```bash
# Cài đặt dependencies
cd ota-v2
npm install

# Login EAS (nếu chưa)
eas login

# Verify configuration
eas update:configure
```

### **2. Build app lần đầu**

```bash
# Build preview cho testing
eas build --platform android --profile preview

# Hoặc dùng GitHub Actions:
# Vào tab "Actions" → "EAS Build" → "Run workflow"
```

**Lưu ý:** Phải build app ít nhất 1 lần trước khi có thể nhận OTA updates!

### **3. Deploy OTA Updates**

#### **Cách 1: Tự động qua Git (Khuyên dùng)**

```bash
# Deploy lên preview channel
git add .
git commit -m "feat: add new feature"
git push origin develop

# Deploy lên production channel
git checkout main
git merge develop
git push origin main
```

#### **Cách 2: Manual qua GitHub Actions**

1. Vào repository → Tab **Actions**
2. Chọn workflow **OTA Update**
3. Click **Run workflow**
4. Chọn:
   - Branch
   - Channel (development/preview/production)
   - Update message
5. Click **Run workflow**

#### **Cách 3: Local manual**

```bash
# Deploy to preview
cd ota-v2
eas update --branch preview --message "Fix critical bug"

# Deploy to production
eas update --branch production --message "v1.0.1 release"
```

### **4. Kiểm tra updates**

```bash
# Xem list updates
eas update:list --branch preview

# Xem chi tiết update
eas update:view [UPDATE_ID]

# Xem channel configuration
eas channel:list
```

## 🧪 Testing

### **Test OTA Updates trên thiết bị:**

#### **Android:**

1. Build preview/production app:
   ```bash
   eas build --platform android --profile preview
   ```

2. Cài đặt APK lên thiết bị

3. Deploy update:
   ```bash
   eas update --branch preview --message "Test update"
   ```

4. Mở app → Force quit → Mở lại
5. Update sẽ được download và apply

#### **Development build:**

```bash
# Build development client
eas build --platform android --profile development

# Start dev server với channel
npx expo start --dev-client

# Trong app, có thể switch channels để test
```

### **Test workflow trong code:**

Thêm vào `app/_layout.tsx` hoặc `App.tsx`:

```typescript
import * as Updates from 'expo-updates';
import { useEffect } from 'react';

export default function RootLayout() {
  useEffect(() => {
    async function checkForUpdates() {
      try {
        const update = await Updates.checkForUpdateAsync();
        
        if (update.isAvailable) {
          await Updates.fetchUpdateAsync();
          
          // Notify user
          Alert.alert(
            'Update Available',
            'A new update is available. Restart to apply?',
            [
              { text: 'Later', style: 'cancel' },
              { 
                text: 'Restart', 
                onPress: () => Updates.reloadAsync() 
              }
            ]
          );
        }
      } catch (error) {
        console.error('Error checking for updates:', error);
      }
    }

    checkForUpdates();
  }, []);

  // ... rest of your layout
}
```

## 🐛 Troubleshooting

### **1. Updates không được nhận**

**Kiểm tra:**

```bash
# Verify update đã publish
eas update:list --branch [CHANNEL]

# Check app đang ở channel nào
# Thêm vào app để log:
console.log('Channel:', Updates.channel);
console.log('Runtime version:', Updates.runtimeVersion);
```

**Nguyên nhân thường gặp:**
- App và update khác runtime version
- App chưa được build với EAS
- Wrong channel configuration
- Chưa force quit & reopen app

### **2. Build failed trên GitHub Actions**

```bash
# Check EXPO_TOKEN
# Settings → Secrets → EXPO_TOKEN phải valid

# Re-generate token:
eas login
eas whoami
# Copy token từ ~/.expo/state.json hoặc dùng:
eas token:create
```

### **3. "No updates available"**

```bash
# Verify channel mapping trong eas.json
# Build profile channel phải match với update channel

# Example fix:
{
  "build": {
    "preview": {
      "channel": "preview"  // ← Phải match
    }
  },
  "update": {
    "preview": {
      "channel": "preview"  // ← Phải match
    }
  }
}
```

### **4. Runtime version mismatch**

**Error:** `The update is incompatible with this app`

**Fix:**

```json
// app.json
{
  "expo": {
    "runtimeVersion": {
      "policy": "sdkVersion"  // Hoặc custom version
    }
  }
}
```

Phải rebuild app sau khi đổi runtime version!

## 📊 Best Practices

### **1. Branching Strategy**

```
main (production channel)
  ↑
develop (preview channel)
  ↑
feature/* (development channel)
```

### **2. Update Message Convention**

```bash
# Good ✅
eas update --message "fix: resolve login crash on Android"
eas update --message "feat: add dark mode support"
eas update --message "perf: optimize image loading"

# Bad ❌
eas update --message "update"
eas update --message "changes"
```

### **3. Testing Flow**

```
1. Develop feature
   ↓
2. Deploy to development channel → Test
   ↓
3. Deploy to preview channel → QA testing
   ↓
4. Deploy to production channel → All users
```

### **4. Rollback Strategy**

```bash
# List updates để lấy ID
eas update:list --branch production

# Rollback bằng cách publish lại update cũ
eas update:republish --group [OLD_UPDATE_GROUP_ID]
```

### **5. Monitor Updates**

- Vào Expo dashboard: https://expo.dev
- Project → Updates → Xem stats
- Monitor crash rates sau mỗi update
- Có rollback plan sẵn

## 🔗 Useful Commands

```bash
# View all channels
eas channel:list

# View updates on channel
eas update:list --branch production

# View specific update details
eas update:view [UPDATE_ID]

# Rollback
eas update:republish --group [UPDATE_GROUP_ID]

# Delete channel
eas channel:delete [CHANNEL_NAME]

# View build list
eas build:list --platform android

# Configure updates
eas update:configure
```

## 📚 Tài liệu tham khảo

- [Expo Updates Documentation](https://docs.expo.dev/eas-update/introduction/)
- [EAS Build Documentation](https://docs.expo.dev/build/introduction/)
- [GitHub Actions for Expo](https://docs.expo.dev/build/building-on-ci/)
- [Runtime Versions](https://docs.expo.dev/eas-update/runtime-versions/)

## 🤝 Contributing

Nếu gặp vấn đề hoặc có suggestions, hãy tạo issue trên GitHub!

## 📝 License

MIT


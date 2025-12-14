# ✅ OTA Setup Checklist

## 📋 Pre-deployment Checklist

### 1. **Cấu hình cơ bản**

- [x] `eas.json` đã được tạo với cấu hình build & update profiles
- [x] `app.json` có `runtimeVersion` và `updates.url`
- [x] `expo-updates` đã được cài đặt trong `package.json`
- [x] EAS `projectId` đã được cấu hình trong `app.json`

### 2. **GitHub Configuration**

- [ ] Repository đã được tạo trên GitHub
- [ ] `EXPO_TOKEN` đã được thêm vào GitHub Secrets
  - Vào: Settings → Secrets and variables → Actions → New repository secret
  - Name: `EXPO_TOKEN`
  - Value: Token từ `eas whoami` hoặc `eas token:create`
- [ ] GitHub Actions workflows đã được commit
  - `.github/workflows/ota-update.yml`
  - `.github/workflows/eas-build.yml`

### 3. **Local Development Setup**

- [ ] EAS CLI đã được cài đặt globally
  ```bash
  npm install -g eas-cli
  ```
- [ ] Đã login vào EAS
  ```bash
  eas login
  eas whoami  # Verify login
  ```
- [ ] Dependencies đã được cài đặt
  ```bash
  cd ota-v2
  npm install
  ```

### 4. **Build Initial App**

- [ ] Build app lần đầu (bắt buộc trước khi OTA hoạt động)
  ```bash
  # For testing - build APK
  eas build --platform android --profile preview
  
  # Or use GitHub Actions workflow
  ```
- [ ] Download và cài đặt APK lên thiết bị test
- [ ] Verify app chạy được

---

## 🧪 Testing Checklist

### 5. **Test OTA Update Flow**

- [ ] **Test local update:**
  ```bash
  cd ota-v2
  eas update --branch preview --message "Test OTA update"
  ```

- [ ] **Verify update trên app:**
  1. Force quit app
  2. Mở lại app
  3. Check component "OTA Update Manager" trên home screen
  4. Click "Check for Updates"
  5. Verify update được detect và download

- [ ] **Test automatic update:**
  1. Deploy update
  2. Force quit app
  3. Mở lại app
  4. Update sẽ tự động download trong background

### 6. **Test GitHub Actions**

- [ ] **Test automatic trigger:**
  ```bash
  # Make a change
  echo "// Test update" >> ota-v2/app/(tabs)/index.tsx
  
  git add .
  git commit -m "test: OTA update via GitHub Actions"
  git push origin develop  # Deploy to preview
  ```

- [ ] **Check workflow execution:**
  1. Vào GitHub repository
  2. Tab "Actions"
  3. Verify workflow "OTA Update" đang chạy
  4. Check logs để đảm bảo thành công

- [ ] **Test manual trigger:**
  1. Vào GitHub repository → Actions
  2. Chọn workflow "OTA Update"
  3. Click "Run workflow"
  4. Chọn channel và message
  5. Click "Run workflow"
  6. Verify thành công

### 7. **Verify Channel Configuration**

- [ ] List all channels:
  ```bash
  eas channel:list
  ```

- [ ] Should see:
  - `development`
  - `preview`
  - `production`

- [ ] Check updates on each channel:
  ```bash
  eas update:list --branch preview
  eas update:list --branch production
  ```

---

## 🚀 Production Deployment Checklist

### 8. **Before going to production**

- [ ] Đã test thoroughly trên preview channel
- [ ] Không có critical bugs
- [ ] Update message rõ ràng và có ý nghĩa
- [ ] Có plan rollback nếu cần

### 9. **Deploy to production**

- [ ] **Option 1: Merge to main branch**
  ```bash
  git checkout main
  git merge develop
  git push origin main
  ```

- [ ] **Option 2: Manual GitHub Actions**
  - Actions → OTA Update → Run workflow
  - Select: channel = `production`

- [ ] **Option 3: Local deploy**
  ```bash
  eas update --branch production --message "v1.0.1: Fix critical bug"
  ```

### 10. **Monitor production update**

- [ ] Check update statistics:
  - Vào https://expo.dev
  - Project → Updates
  - Monitor download/success rates

- [ ] Monitor crash reports
- [ ] Ready to rollback if needed:
  ```bash
  eas update:list --branch production
  eas update:republish --group [OLD_UPDATE_GROUP_ID]
  ```

---

## 🔧 Troubleshooting Checklist

### Common Issues

- [ ] **"No updates available"**
  - Verify runtimeVersion match giữa app và update
  - Verify channel configuration đúng
  - Check: `eas update:list --branch [channel]`

- [ ] **"Update incompatible"**
  - RuntimeVersion mismatch
  - Cần rebuild app với EAS

- [ ] **GitHub Actions failed**
  - Verify EXPO_TOKEN còn valid
  - Check workflow logs
  - Re-generate token: `eas token:create`

- [ ] **Updates không được apply**
  - Phải force quit và reopen app
  - Không hoạt động trong development mode (__DEV__ = true)
  - Cần build với EAS để test OTA

---

## 📊 Helper Commands

```bash
# Quick update to preview
./scripts/ota-helper.sh

# Or manual commands:
eas update --branch preview --message "Your message"
eas update:list --branch preview
eas channel:list
eas update:view [UPDATE_ID]
eas update:republish --group [GROUP_ID]  # Rollback

# Build commands
eas build --platform android --profile preview
eas build --platform ios --profile preview
eas build:list
```

---

## 📚 Next Steps

Sau khi hoàn thành checklist này:

1. ✅ Commit và push tất cả changes lên GitHub
2. ✅ Build app lần đầu với EAS
3. ✅ Cài đặt app lên thiết bị test
4. ✅ Test OTA update flow
5. ✅ Setup branch strategy (main = production, develop = preview)
6. ✅ Document flow cho team

**Tham khảo:** Xem file `OTA_GUIDE.md` để có hướng dẫn chi tiết hơn.


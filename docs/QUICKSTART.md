# 🚀 Quick Start Guide - OTA Updates

## ⚡ 5 Bước để Deploy OTA Update

### 1️⃣ **Verify EXPO_TOKEN trên GitHub**

Vào repository → **Settings** → **Secrets and variables** → **Actions**

Phải có secret: `EXPO_TOKEN`

**Chưa có?** Tạo token:
```bash
eas login
eas token:create
# Copy token và add vào GitHub Secrets
```

---

### 2️⃣ **Build App Lần Đầu** (Bắt buộc!)

**Via GitHub Actions (Dễ nhất):**

1. Vào GitHub repo → Tab **Actions**
2. Select **EAS Build** workflow
3. Click **Run workflow**
4. Choose:
   - Platform: `android`
   - Profile: `preview`
5. Wait ~15 minutes
6. Download APK và cài lên device

**Via Terminal:**
```bash
cd ota-v2
eas build --platform android --profile preview
```

---

### 3️⃣ **Deploy OTA Update**

**Cách 1: Push to Git (Auto) - RECOMMENDED ✨**

```bash
# Edit code
vim ota-v2/app/(tabs)/index.tsx

# Commit & push to develop
git add .
git commit -m "feat: add new feature"
git push origin develop

# GitHub Actions sẽ tự động deploy to preview channel!
```

**Cách 2: Manual via Script**

```bash
./scripts/ota-helper.sh
# Select option 2 (Deploy to PREVIEW)
# Enter message
```

**Cách 3: Manual via Command**

```bash
cd ota-v2
eas update --branch preview --message "Bug fix"
```

---

### 4️⃣ **Test Update trên Device**

1. **Force quit** app (swipe từ recent apps)
2. **Mở lại** app
3. Update sẽ tự động download
4. App reload → Update applied! ✅

**Manual check:**
- Mở app
- Vào Home screen
- Scroll down đến "OTA Update Manager"
- Click "Check for Updates"

---

### 5️⃣ **Deploy to Production**

```bash
# Merge develop to main
git checkout main
git merge develop
git push origin main

# GitHub Actions auto deploy to production! 🎉
```

---

## 🔄 Workflow Tóm Tắt

```
Development
    ↓ (feature branch → develop)
Preview Channel (QA Testing)
    ↓ (develop → main)
Production Channel (Users)
```

**Branch Strategy:**
- `main` → production channel
- `develop` → preview channel
- `feature/*` → development channel

---

## 📱 Testing on Device

### Android APK Installation

```bash
# Option 1: Download from EAS dashboard
# https://expo.dev → Your project → Builds → Download

# Option 2: Use QR code from build output
# Scan QR with phone camera

# Option 3: adb install
adb install /path/to/app.apk
```

### Verify OTA is Working

```bash
# Check update info in app
# OTA Update Manager component shows:
# - Update ID
# - Channel
# - Runtime Version

# Deploy test update
eas update --branch preview --message "Test"

# Force quit + reopen app
# Should see new update
```

---

## 🛠️ Useful Commands

```bash
# See all updates
eas update:list --branch preview

# See all channels
eas channel:list

# Rollback
eas update:list --branch production
eas update:republish --group [GROUP_ID]

# Check config
eas project:info
eas whoami
```

---

## ⚠️ Common Mistakes

❌ **Không build app trước**
- OTA chỉ work với apps built bằng EAS
- Phải build ít nhất 1 lần!

❌ **Test trong development mode**
- `expo start` không support OTA
- Phải build với `eas build`

❌ **Không force quit app**
- Update chỉ check khi app restart
- Phải force quit & reopen

❌ **RuntimeVersion mismatch**
- Update và app phải cùng runtime version
- Rebuild app nếu thay đổi Expo SDK

---

## 🎯 Next Steps

1. ✅ Build app với EAS
2. ✅ Cài app lên device
3. ✅ Make code change
4. ✅ Deploy OTA update
5. ✅ Test on device
6. ✅ Deploy to production when ready

**Need more details?**
- Complete guide: `/OTA_GUIDE.md`
- Step-by-step: `/OTA_CHECKLIST.md`
- Troubleshooting: `/OTA_GUIDE.md#troubleshooting`

---

## 💡 Pro Tips

✨ **Automatic Updates via Git**
```bash
# Setup once
git checkout -b develop
git push -u origin develop

# Then just:
git add . && git commit -m "feat: xyz" && git push
# Auto deploy to preview! 🚀
```

✨ **Monitor Updates**
- https://expo.dev → Your project → Updates
- See download stats, success rate
- Monitor crashes

✨ **Rollback Instantly**
```bash
eas update:list --branch production
eas update:republish --group [PREVIOUS_GROUP_ID]
```

---

**Ready to go?** Start with Step 1! 🎉


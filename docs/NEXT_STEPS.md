# ✅ NEXT STEPS - Những việc bạn cần làm

## 🎯 Tổng quan

Setup OTA đã **HOÀN TẤT** ✅. Các file đã được tạo và cấu hình đúng.

**Những gì bạn cần làm tiếp:**

---

## 📝 Checklist (Làm theo thứ tự)

### ☐ **Step 1: Verify EXPO_TOKEN trên GitHub** (2 phút)

```bash
# 1.1. Get token từ EAS
eas whoami  # Check if logged in

# Nếu chưa login:
eas login

# 1.2. Create token
eas token:create

# 1.3. Copy token và add vào GitHub
```

**Thêm vào GitHub:**
1. Vào https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2
2. Settings → Secrets and variables → Actions
3. Click **New repository secret**
4. Name: `EXPO_TOKEN`
5. Value: [paste token]
6. Click **Add secret**

✅ **Verify:** Secret `EXPO_TOKEN` hiển thị trong list

---

### ☐ **Step 2: Push Code lên GitHub** (2 phút)

```bash
cd /Users/admin/test-ota-v2

# Check status
git status

# Add all files
git add .

# Commit
git commit -m "feat: complete OTA setup with CI/CD and documentation"

# Push to main
git push origin main

# Create and push develop branch
git checkout -b develop
git push -u origin develop
git checkout main
```

✅ **Verify:** Vào GitHub repo, thấy all files đã được push

---

### ☐ **Step 3: Build App Lần Đầu** (15-20 phút)

**⚠️ QUAN TRỌNG:** OTA chỉ hoạt động với apps đã build bằng EAS!

**Option A: Via GitHub Actions (RECOMMENDED)**

1. Vào https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2
2. Tab **Actions**
3. Select workflow: **EAS Build**
4. Click **Run workflow** (màu xanh)
5. Chọn:
   - **Branch:** `main`
   - **Platform:** `android`
   - **Profile:** `preview`
6. Click **Run workflow**
7. Wait ~15-20 phút
8. Sau khi complete, click vào workflow run
9. Scroll down logs, tìm link download APK
10. Download APK về máy

**Option B: Via Terminal**

```bash
cd /Users/admin/test-ota-v2/ota-v2

# Build preview APK
eas build --platform android --profile preview --non-interactive

# Wait for build
# Link download sẽ hiển thị khi xong
```

✅ **Verify:** Download được APK file

---

### ☐ **Step 4: Cài App lên Thiết bị Android** (3 phút)

**Method 1: Direct install (nếu có file APK trên máy)**

```bash
# Enable USB debugging trên phone
# Connect phone to computer
adb install /path/to/downloaded.apk
```

**Method 2: Transfer & install**

1. Copy APK file vào phone (USB/AirDrop/Email)
2. Trên phone, mở File Manager
3. Tap vào APK file
4. Allow install from unknown sources (nếu prompted)
5. Install

**Method 3: QR Code (từ EAS Build)**

1. EAS build sẽ generate QR code
2. Scan QR với phone camera
3. Download & install

✅ **Verify:** App mở được và chạy bình thường

---

### ☐ **Step 5: Test OTA Update** (5 phút)

```bash
cd /Users/admin/test-ota-v2/ota-v2

# 5.1. Make a visible change
# Ví dụ: Edit app/(tabs)/index.tsx
# Change text "Welcome!" to "Welcome to OTA Test!"
```

Edit file:
```bash
# Open in editor
code app/(tabs)/index.tsx

# Or use nano/vim
nano app/(tabs)/index.tsx
```

```bash
# 5.2. Deploy update
eas update --branch preview --message "Test: Change welcome text"

# Wait for upload to complete (~30 seconds)
```

```bash
# 5.3. Test trên device
# - Force quit app (swipe up from recent apps)
# - Mở lại app
# - Chờ 2-3 giây
# - App sẽ reload
# - Thấy text đã đổi! ✅
```

**Alternative test:**
1. Mở app
2. Scroll down đến **OTA Update Manager** component
3. Click **"Check for Updates"**
4. App sẽ báo có update
5. Click download
6. Click restart
7. Thấy changes! ✅

✅ **Verify:** Thấy thay đổi trong app sau khi restart

---

### ☐ **Step 6: Test GitHub Actions Auto Deploy** (5 phút)

```bash
cd /Users/admin/test-ota-v2

# 6.1. Switch to develop branch
git checkout develop

# 6.2. Make another change
echo "// Test GitHub Actions" >> ota-v2/app/(tabs)/explore.tsx

# 6.3. Commit and push
git add .
git commit -m "test: trigger OTA via GitHub Actions"
git push origin develop

# 6.4. Check GitHub Actions
# Vào https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions
# Sẽ thấy workflow "OTA Update" đang chạy
```

**Wait for workflow to complete (~2 phút)**

```bash
# 6.5. Test trên device
# Force quit & reopen app
# Update sẽ được nhận!
```

✅ **Verify:** 
- Workflow chạy thành công (green check mark)
- App nhận được update

---

### ☐ **Step 7: Setup Branch Strategy** (2 phút)

```bash
# Đảm bảo có đủ 2 branches
git checkout main
git checkout develop

# Setup upstream
git branch --set-upstream-to=origin/main main
git branch --set-upstream-to=origin/develop develop
```

**Branch strategy:**
- `main` → production channel (cho users thật)
- `develop` → preview channel (cho QA/testing)
- `feature/*` → development channel (cho dev)

✅ **Verify:** `git branch -a` shows main và develop

---

## 🎉 Xong! Bạn đã setup thành công OTA!

### ✅ Những gì đã hoàn thành:

1. ✅ Cấu hình `eas.json` và `app.json`
2. ✅ Setup GitHub Actions workflows
3. ✅ Created helper scripts
4. ✅ Added OTA Update Manager component
5. ✅ Complete documentation
6. ✅ EXPO_TOKEN in GitHub Secrets
7. ✅ Build app lần đầu
8. ✅ Test OTA updates
9. ✅ Test GitHub Actions auto deploy

---

## 🚀 Daily Workflow (Sau khi setup xong)

### Development Flow

```bash
# 1. Create feature branch
git checkout develop
git pull
git checkout -b feature/my-feature

# 2. Make changes
# ... code code code ...

# 3. Push to trigger development channel update
git add .
git commit -m "feat: add my feature"
git push origin feature/my-feature

# 4. Test locally first
eas update --branch development --message "Test feature"

# 5. Merge to develop for QA
git checkout develop
git merge feature/my-feature
git push origin develop
# ✅ Auto deploy to preview channel

# 6. After QA approval, merge to main
git checkout main
git merge develop
git push origin main
# ✅ Auto deploy to production channel
```

### Quick Update

```bash
# Make small fix
vim ota-v2/app/(tabs)/index.tsx

# Deploy to preview
git add . && git commit -m "fix: typo" && git push origin develop
# Done! ✅
```

### Emergency Rollback

```bash
# List recent updates
eas update:list --branch production

# Rollback to previous
eas update:republish --group [PREVIOUS_GROUP_ID]
# Done! ✅
```

---

## 📚 Tài liệu tham khảo

Khi cần thông tin chi tiết:

| File | Mục đích | Khi nào dùng |
|------|----------|--------------|
| **QUICKSTART.md** | 5 bước quick start | Cần nhớ lại workflow |
| **OTA_GUIDE.md** | Complete guide | Cần hiểu sâu hoặc troubleshoot |
| **OTA_CHECKLIST.md** | Step-by-step checklist | Setup từ đầu hoặc verify |
| **ENV_SETUP.md** | Secrets & environment | Setup tokens/variables |
| **SETUP_SUMMARY.md** | Summary của config | Review những gì đã làm |

---

## 🐛 Gặp vấn đề?

### "No updates available"
→ Force quit & reopen app
→ Check channel: `eas channel:list`

### "Update incompatible"
→ Rebuild app: `eas build --platform android --profile preview`

### GitHub Actions failed
→ Check EXPO_TOKEN in Secrets
→ Verify token: `eas whoami`

**Full troubleshooting:** [OTA_GUIDE.md#troubleshooting](OTA_GUIDE.md#troubleshooting)

---

## 💡 Pro Tips

✨ **Auto deploy via Git**
- Push to `develop` → auto deploy to preview
- Push to `main` → auto deploy to production

✨ **Use helper script**
```bash
./scripts/ota-helper.sh
# Interactive menu for all operations
```

✨ **Monitor updates**
- https://expo.dev → Your project → Updates
- See real-time stats

✨ **Test before production**
- Always test on preview channel first
- Get QA approval
- Then merge to main for production

---

## ✅ Final Checklist

Trước khi kết thúc, verify:

- [ ] EXPO_TOKEN added to GitHub Secrets
- [ ] Code pushed to GitHub (main & develop branches)
- [ ] App built với EAS (có APK file)
- [ ] App installed on device
- [ ] OTA update tested successfully (manual)
- [ ] GitHub Actions tested successfully (auto)
- [ ] Understand daily workflow
- [ ] Know where to find documentation

**All checked?** 🎉 **CONGRATULATIONS!** Setup hoàn tất!

---

## 📞 Need Help?

1. Check documentation: [OTA_GUIDE.md](OTA_GUIDE.md)
2. Follow checklist: [OTA_CHECKLIST.md](OTA_CHECKLIST.md)
3. Read troubleshooting section
4. Open GitHub Issue
5. Ask on Expo Discord: https://chat.expo.dev

---

<div align="center">

**🚀 Ready to deploy! Good luck!**

Made with ❤️

</div>


# 🧪 Testing Guide - OTA & CI/CD

Hướng dẫn test OTA Updates và CI/CD workflows.

---

## ✅ Local Testing Results

### **Configuration Test** ✅

Đã chạy test script và **TẤT CẢ đều PASS**:

```bash
./scripts/test-ota.sh
```

**Results:**
- ✅ EAS CLI installed (v16.28.0)
- ✅ EAS authentication (logged in as hieunguyenminh1810)
- ✅ Project connected (ID: 786c8988-cb81-40ea-b91a-afb92b812194)
- ✅ eas.json valid
- ✅ app.json valid (runtimeVersion: sdkVersion)
- ✅ expo-updates installed (v29.0.15)
- ✅ GitHub workflows found
- ✅ OTA update command works

---

## 🧪 Test Methods

### **1. Local OTA Update Test**

#### **Test Command:**

```bash
cd /Users/admin/test-ota-v2/ota-v2

# Deploy test update
eas update --branch preview --message "Test OTA update"
```

#### **Expected Result:**
- ✅ Bundle created
- ✅ Assets uploaded
- ✅ Update published to preview channel
- ✅ Success message displayed

#### **Verify Update:**

```bash
# List updates on channel
eas update:list --branch preview

# View channels
eas channel:list
```

---

### **2. GitHub Actions Test**

#### **Method 1: Manual Trigger (Recommended for First Test)**

1. **Vào GitHub Repository:**
   - https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2

2. **Go to Actions Tab:**
   - Click "Actions" ở top menu

3. **Select Workflow:**
   - Click "OTA Update" workflow (left sidebar)

4. **Run Workflow:**
   - Click "Run workflow" button (right side)
   - Select:
     - **Branch:** `main` hoặc `develop`
     - **Channel:** `preview` (for testing)
     - **Message:** "Test CI/CD OTA update"
   - Click "Run workflow"

5. **Monitor Execution:**
   - Click vào workflow run để xem logs
   - Wait for completion (~2-3 minutes)
   - Check for green checkmark ✅

#### **Method 2: Auto Trigger via Git Push**

```bash
cd /Users/admin/test-ota-v2/ota-v2

# Make a small change
echo "// Test CI/CD" >> app/(tabs)/index.tsx

# Commit and push
git add .
git commit -m "test: trigger OTA via GitHub Actions"
git push origin develop  # Auto deploy to preview channel
```

**Expected:**
- GitHub Actions workflow tự động trigger
- Deploy to preview channel
- Success in ~2-3 minutes

---

### **3. EAS Build Test**

#### **Via GitHub Actions:**

1. **Go to Actions → EAS Build**
2. **Click "Run workflow"**
3. **Select:**
   - Platform: `android`
   - Profile: `preview`
4. **Run and wait** (~15-20 minutes)

#### **Via Terminal:**

```bash
cd /Users/admin/test-ota-v2/ota-v2
eas build --platform android --profile preview
```

---

## 📋 Test Checklist

### **Pre-Testing Setup**

- [ ] ✅ EAS CLI installed (`eas --version`)
- [ ] ✅ Logged in to EAS (`eas whoami`)
- [ ] ✅ Project configured (`eas project:info`)
- [ ] ✅ EXPO_TOKEN added to GitHub Secrets
- [ ] ✅ Code pushed to GitHub

### **Local OTA Test**

- [ ] ✅ Run test script: `./scripts/test-ota.sh`
- [ ] ✅ Test OTA update: `eas update --branch preview --message "Test"`
- [ ] ✅ Verify update listed: `eas update:list --branch preview`

### **GitHub Actions Test**

- [ ] ✅ Manual trigger workflow (via GitHub UI)
- [ ] ✅ Verify workflow completes successfully
- [ ] ✅ Check update deployed: `eas update:list --branch preview`
- [ ] ✅ Test auto trigger (push to develop branch)

### **End-to-End Test**

- [ ] ✅ Build app: `eas build --platform android --profile preview`
- [ ] ✅ Install APK on device
- [ ] ✅ Deploy OTA update
- [ ] ✅ Force quit & reopen app
- [ ] ✅ Verify update received in app

---

## 🔍 Verification Commands

### **Check Configuration:**

```bash
# EAS status
eas whoami
eas project:info

# Channels
eas channel:list

# Updates
eas update:list --branch preview
eas update:list --branch production
```

### **Check GitHub Actions:**

```bash
# View workflow runs
# Go to: https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions

# Check workflow files
cat .github/workflows/ota-update.yml
cat .github/workflows/eas-build.yml
```

### **Check App Configuration:**

```bash
# Verify app.json
cat app.json | grep -A 5 "runtimeVersion"
cat app.json | grep -A 2 "updates"

# Verify eas.json
cat eas.json
```

---

## 🐛 Troubleshooting Tests

### **Issue: "eas.json is not valid"**

**Solution:**
- ✅ Already fixed - removed `"update"` section
- EAS CLI 16.28.0 doesn't support it
- Channels managed automatically via `--branch` flag

### **Issue: "EXPO_TOKEN is not set" in GitHub Actions**

**Solution:**
1. Go to GitHub → Settings → Secrets → Actions
2. Add secret: `EXPO_TOKEN`
3. Get token: `eas token:create`
4. Paste token value
5. Re-run workflow

### **Issue: "No updates available"**

**Possible Causes:**
- App chưa được build với EAS
- Runtime version mismatch
- Wrong channel

**Solution:**
```bash
# Build app first
eas build --platform android --profile preview

# Check runtime version
cat app.json | grep runtimeVersion

# Verify channel
eas channel:list
```

### **Issue: Workflow fails at "Install dependencies"**

**Solution:**
- Check `package-lock.json` exists
- Verify Node.js version (20.x)
- Check workflow cache settings

### **Issue: "Update incompatible"**

**Solution:**
- Rebuild app với EAS
- Ensure runtimeVersion matches
- Check SDK version compatibility

---

## 📊 Expected Test Results

### **Local OTA Update:**

```
✅ Exporting...
✅ Bundling...
✅ Uploading assets...
✅ Publishing update...
✅ Update published successfully!
   Channel: preview
   Update ID: [UUID]
```

### **GitHub Actions Workflow:**

```
✅ Checkout repository
✅ Setup Node.js
✅ Setup Expo
✅ Install dependencies
✅ Determine channel
✅ Publish update
✅ Update summary
```

**Total time:** ~2-3 minutes

---

## 🎯 Success Criteria

### **Local Test Passes When:**
- ✅ Test script runs without errors
- ✅ OTA update command completes
- ✅ Update appears in channel list

### **CI/CD Test Passes When:**
- ✅ Workflow runs successfully (green checkmark)
- ✅ Update deployed to correct channel
- ✅ No errors in workflow logs
- ✅ Update visible in Expo dashboard

### **End-to-End Test Passes When:**
- ✅ App installed on device
- ✅ OTA update deployed
- ✅ App receives update on next launch
- ✅ Changes visible in app

---

## 📝 Test Log Template

```markdown
## Test Date: [DATE]

### Local Test:
- [ ] EAS CLI: ✅
- [ ] Authentication: ✅
- [ ] Project: ✅
- [ ] OTA Update: ✅

### GitHub Actions:
- [ ] Manual Trigger: ✅
- [ ] Auto Trigger: ✅
- [ ] Workflow Success: ✅

### End-to-End:
- [ ] App Build: ✅
- [ ] App Install: ✅
- [ ] Update Deploy: ✅
- [ ] Update Received: ✅

### Issues Found:
- None / [List issues]

### Notes:
- [Any observations]
```

---

## 🚀 Quick Test Commands

```bash
# Run full test suite
./scripts/test-ota.sh

# Test OTA update
eas update --branch preview --message "Test"

# List updates
eas update:list --branch preview

# Check channels
eas channel:list

# View project info
eas project:info
```

---

## 📚 Related Documentation

- **Setup Guide:** [NEXT_STEPS.md](NEXT_STEPS.md)
- **Complete Guide:** [OTA_GUIDE.md](OTA_GUIDE.md)
- **Troubleshooting:** [OTA_GUIDE.md#troubleshooting](OTA_GUIDE.md#troubleshooting)
- **Environment Setup:** [ENV_SETUP.md](ENV_SETUP.md)

---

**Last Updated:** December 14, 2025
**Status:** ✅ All tests passing


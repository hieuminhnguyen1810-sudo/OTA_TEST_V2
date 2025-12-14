# 🚀 OTA Test V2 - Expo React Native with OTA Updates

Complete setup for Over-The-Air (OTA) updates with Expo, React Native, and CI/CD integration via GitHub Actions.

[![EAS Build](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions/workflows/eas-build.yml/badge.svg)](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions/workflows/eas-build.yml)
[![OTA Update](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions/workflows/ota-update.yml/badge.svg)](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/actions/workflows/ota-update.yml)

---

## 📋 What is OTA?

**Over-The-Air Updates** cho phép bạn deploy code changes (JavaScript, TypeScript, assets) trực tiếp đến users mà không cần rebuild app hoặc resubmit lên App Store/Play Store.

### ✅ Update được qua OTA:
- ✅ JavaScript/TypeScript code
- ✅ React components & UI
- ✅ Business logic
- ✅ Images, fonts, assets
- ✅ Styling

### ❌ KHÔNG update được qua OTA:
- ❌ Native code (Java, Kotlin, Swift, Obj-C)
- ❌ Native dependencies mới
- ❌ App permissions mới
- ❌ Native configuration changes

---

## 🎯 Features

- ✨ **Automatic OTA Deployment** via GitHub Actions
- 🔄 **3 Update Channels**: development, preview, production
- 📱 **In-App Update Manager** để test OTA
- 🛠️ **Helper Scripts** cho easy management
- 📚 **Complete Documentation** with troubleshooting
- 🔐 **Secure** với GitHub Secrets
- 📊 **Monitoring** via Expo Dashboard

---

## 🚀 Quick Start

### 1. Clone & Install

```bash
git clone https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2.git
cd OTA_TEST_V2/ota-v2
npm install
```

### 2. Setup Expo Token

```bash
# Login to EAS
eas login

# Create token
eas token:create

# Add to GitHub Secrets:
# Settings → Secrets → Actions → New secret
# Name: EXPO_TOKEN
# Value: [token from above]
```

### 3. Build Initial App

```bash
# Via GitHub Actions (recommended)
# Go to Actions → EAS Build → Run workflow

# Or via terminal:
eas build --platform android --profile preview
```

### 4. Deploy OTA Update

```bash
# Make code changes
# Then commit and push:

git add .
git commit -m "feat: new feature"
git push origin develop  # Auto deploy to preview channel!
```

### 5. Test on Device

1. Install APK from Step 3
2. Force quit & reopen app
3. Update auto downloads! ✅

**📖 Detailed instructions:** See [QUICKSTART.md](QUICKSTART.md)

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       ├── ota-update.yml       # Auto OTA deployment
│       └── eas-build.yml        # Manual app builds
│
├── ota-v2/                      # Expo React Native app
│   ├── app/                     # App screens (Expo Router)
│   ├── components/
│   │   └── ota-update-manager.tsx   # OTA testing UI
│   ├── app.json                 # Expo config
│   ├── eas.json                 # EAS Build & Update config
│   └── package.json
│
├── scripts/
│   └── ota-helper.sh           # Interactive OTA management
│
└── Documentation/
    ├── QUICKSTART.md           # ⚡ Start here!
    ├── OTA_GUIDE.md            # Complete guide
    ├── OTA_CHECKLIST.md        # Step-by-step checklist
    ├── ENV_SETUP.md            # Secrets & environment
    └── SETUP_SUMMARY.md        # What was configured
```

---

## 🔄 Workflow

### Automatic Deployment (GitHub Actions)

```
Push to branch → GitHub Actions → Deploy OTA Update
    ↓
main branch      → production channel
develop branch   → preview channel
other branches   → development channel
```

### Manual Deployment

```bash
# Via helper script (interactive)
./scripts/ota-helper.sh

# Via command
cd ota-v2
eas update --branch preview --message "Bug fix"
```

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [**QUICKSTART.md**](QUICKSTART.md) | ⚡ 5 bước để deploy OTA - Start here! |
| [**OTA_GUIDE.md**](OTA_GUIDE.md) | 📖 Complete guide với examples & troubleshooting |
| [**OTA_CHECKLIST.md**](OTA_CHECKLIST.md) | ✅ Step-by-step checklist để verify setup |
| [**ENV_SETUP.md**](ENV_SETUP.md) | 🔐 Environment variables & secrets setup |
| [**SETUP_SUMMARY.md**](SETUP_SUMMARY.md) | 📊 Summary of what was configured |

**Recommended reading order:**
1. QUICKSTART.md (5 minutes)
2. OTA_CHECKLIST.md (follow step-by-step)
3. OTA_GUIDE.md (when you need details)

---

## 🛠️ Tech Stack

- **Framework:** [Expo](https://expo.dev) ~54.0
- **Runtime:** React Native 0.81 + React 19
- **Routing:** [Expo Router](https://docs.expo.dev/router/introduction/) v6
- **OTA:** [EAS Update](https://docs.expo.dev/eas-update/introduction/)
- **Build:** [EAS Build](https://docs.expo.dev/build/introduction/)
- **CI/CD:** GitHub Actions
- **Language:** TypeScript

---

## 📱 Update Channels

| Channel | Branch | Purpose | Auto Deploy |
|---------|--------|---------|-------------|
| **development** | `feature/*` | Local dev & testing | ✅ |
| **preview** | `develop` | QA & Beta testing | ✅ |
| **production** | `main` | Production users | ✅ |

---

## 🎮 Usage Examples

### Deploy to Preview

```bash
git checkout develop
# Make changes...
git add . && git commit -m "feat: new feature"
git push origin develop
# ✅ Auto deploys to preview channel
```

### Deploy to Production

```bash
git checkout main
git merge develop
git push origin main
# ✅ Auto deploys to production channel
```

### Manual Deploy with Choice

```bash
# Interactive helper
./scripts/ota-helper.sh

# Or manual command
eas update --branch production --message "v1.0.1: Critical bug fix"
```

### Rollback

```bash
# List updates
eas update:list --branch production

# Rollback to previous
eas update:republish --group [PREVIOUS_GROUP_ID]
```

### View Update Stats

```bash
# List all updates on channel
eas update:list --branch preview

# View specific update
eas update:view [UPDATE_ID]

# List all channels
eas channel:list
```

---

## 🧪 Testing

### In-App Testing

App có sẵn **OTA Update Manager** component trên home screen:

- Hiển thị current update info
- Manual "Check for Updates" button
- Download & apply updates
- Force reload

### Testing Flow

```bash
# 1. Build & install app
eas build --platform android --profile preview

# 2. Deploy update
eas update --branch preview --message "Test update"

# 3. On device:
#    - Force quit app
#    - Reopen app
#    - Update auto downloads
```

---

## 🐛 Troubleshooting

### "No updates available"

- ✅ Force quit & reopen app
- ✅ Check channel configuration
- ✅ Verify runtime version matches

### "Update incompatible"

- ✅ RuntimeVersion mismatch
- ✅ Rebuild app with EAS

### GitHub Actions failed

- ✅ Verify EXPO_TOKEN in Secrets
- ✅ Re-generate token if expired
- ✅ Check workflow logs

**Full troubleshooting guide:** [OTA_GUIDE.md#troubleshooting](OTA_GUIDE.md#troubleshooting)

---

## 📊 Monitoring

### Via Expo Dashboard

https://expo.dev → Your project → Updates

- View all deployed updates
- Download statistics
- Success/failure rates
- Crash reports

### Via CLI

```bash
# View updates
eas update:list --branch production

# View channels
eas channel:list

# Project info
eas project:info
```

---

## 🔐 Security

- ✅ EXPO_TOKEN stored as GitHub Secret
- ✅ Never commit tokens to git
- ✅ Use .gitignore for sensitive files
- ✅ Rotate tokens regularly
- ✅ Limit token permissions

**Full security guide:** [ENV_SETUP.md](ENV_SETUP.md)

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

---

## 📝 Scripts

```bash
# Interactive OTA helper
./scripts/ota-helper.sh

# App scripts
cd ota-v2
npm start              # Start dev server
npm run android        # Run on Android
npm run ios            # Run on iOS
npm run lint           # Run linter
```

---

## 🔗 Useful Links

- **Expo Documentation:** https://docs.expo.dev
- **EAS Update Guide:** https://docs.expo.dev/eas-update/introduction/
- **EAS Build Guide:** https://docs.expo.dev/build/introduction/
- **Expo Router:** https://docs.expo.dev/router/introduction/
- **GitHub Actions for Expo:** https://docs.expo.dev/build/building-on-ci/

---

## 📄 License

MIT License - see LICENSE file for details

---

## 👤 Author

**Hieu Minh Nguyen**
- GitHub: [@hieuminhnguyen1810-sudo](https://github.com/hieuminhnguyen1810-sudo)
- Project: [OTA_TEST_V2](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2)

---

## 🙏 Acknowledgments

- [Expo Team](https://expo.dev) for amazing tools
- [React Native Community](https://reactnative.dev)
- [GitHub Actions](https://github.com/features/actions)

---

## 📞 Support

- 📖 Check [Documentation](OTA_GUIDE.md)
- ✅ Follow [Checklist](OTA_CHECKLIST.md)
- ❓ Open an [Issue](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/issues)
- 💬 [Expo Discord](https://chat.expo.dev)

---

<div align="center">

**⭐ Star this repo if it helped you!**

Made with ❤️ using Expo & React Native

[Report Bug](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/issues) · [Request Feature](https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2/issues)

</div>


# 📚 Documentation Index

## 🎯 Mục đích

Repository này chứa complete setup cho **OTA (Over-The-Air) Updates** với Expo React Native và CI/CD integration via GitHub Actions.

---

## 🚀 Bắt đầu nhanh

**Lần đầu tiên?** Đọc theo thứ tự:

1. **[README.md](README.md)** (5 phút)
   - Overview của project
   - Features & Tech stack
   - Quick start 5 bước

2. **[QUICKSTART.md](QUICKSTART.md)** (5 phút)
   - ⚡ Fast-track guide
   - 5 bước deploy OTA update
   - Essential commands

3. **[NEXT_STEPS.md](NEXT_STEPS.md)** (10 phút)
   - ✅ Checklist những việc cần làm
   - Step-by-step instructions
   - Verification cho mỗi bước

---

## 📖 Documentation đầy đủ

### Core Guides

| Document | Description | Khi nào đọc |
|----------|-------------|-------------|
| **[OTA_GUIDE.md](OTA_GUIDE.md)** | Complete comprehensive guide | Khi cần hiểu sâu về OTA, troubleshoot, best practices |
| **[OTA_CHECKLIST.md](OTA_CHECKLIST.md)** | Step-by-step verification checklist | Setup từ đầu hoặc audit existing setup |
| **[SETUP_SUMMARY.md](SETUP_SUMMARY.md)** | Summary của config đã làm | Review những gì đã được cấu hình |

### Configuration & Setup

| Document | Description | Khi nào đọc |
|----------|-------------|-------------|
| **[ENV_SETUP.md](ENV_SETUP.md)** | Environment & secrets setup | Cần setup EXPO_TOKEN, env variables |
| **[WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md)** | Visual workflows & diagrams | Cần hiểu flow, architecture |

### Quick Reference

| Document | Description | Khi nào đọc |
|----------|-------------|-------------|
| **[QUICKSTART.md](QUICKSTART.md)** | 5-step quick guide | Cần deploy nhanh, cheat sheet |
| **[NEXT_STEPS.md](NEXT_STEPS.md)** | Action items checklist | Sau khi setup, cần biết làm gì tiếp |

---

## 📂 Project Structure

```
/Users/admin/test-ota-v2/
│
├── 📄 README.md                    # Main project documentation
├── 📄 INDEX.md                     # This file - documentation navigator
│
├── 🚀 Quick Start Documents
│   ├── QUICKSTART.md               # 5-step fast track
│   └── NEXT_STEPS.md               # What to do after setup
│
├── 📚 Comprehensive Guides
│   ├── OTA_GUIDE.md                # Complete OTA guide
│   ├── OTA_CHECKLIST.md            # Verification checklist
│   ├── SETUP_SUMMARY.md            # Configuration summary
│   ├── ENV_SETUP.md                # Environment setup
│   └── WORKFLOW_DIAGRAM.md         # Visual workflows
│
├── 🤖 CI/CD Configuration
│   └── .github/
│       └── workflows/
│           ├── ota-update.yml      # Auto OTA deployment
│           └── eas-build.yml       # Manual app builds
│
├── 🛠️ Helper Scripts
│   └── scripts/
│       └── ota-helper.sh           # Interactive OTA manager
│
└── 📱 Expo React Native App
    └── ota-v2/
        ├── app/                    # App screens (Expo Router)
        ├── components/
        │   └── ota-update-manager.tsx  # OTA test UI
        ├── app.json                # Expo configuration
        ├── eas.json                # EAS Build & Update config
        └── package.json            # Dependencies
```

---

## 🗺️ Reading Paths

### Path 1: Complete Beginner (Lần đầu setup OTA)

```
1. README.md              (Overview)
   ↓
2. QUICKSTART.md          (Fast introduction)
   ↓
3. NEXT_STEPS.md          (Follow checklist)
   ↓
4. ENV_SETUP.md           (Setup tokens)
   ↓
5. OTA_GUIDE.md           (Deep understanding)
   ↓
6. WORKFLOW_DIAGRAM.md    (Visualize flow)
```

**Time estimate:** 1-2 hours + build time

---

### Path 2: Experienced Developer (Đã biết Expo, mới với OTA)

```
1. README.md              (Quick scan)
   ↓
2. SETUP_SUMMARY.md       (What's configured)
   ↓
3. QUICKSTART.md          (Commands & workflow)
   ↓
4. OTA_CHECKLIST.md       (Verify setup)
```

**Time estimate:** 30 minutes

---

### Path 3: Quick Reference (Đã setup, cần reference)

```
1. QUICKSTART.md          (Commands)
   ↓
2. OTA_GUIDE.md           (Specific topics)
   └─ Troubleshooting section
```

**Time estimate:** 5 minutes per lookup

---

### Path 4: Audit/Review Existing Setup

```
1. SETUP_SUMMARY.md       (What should be configured)
   ↓
2. OTA_CHECKLIST.md       (Verify each item)
   ↓
3. OTA_GUIDE.md           (Fix any issues)
   └─ Troubleshooting
```

**Time estimate:** 20-30 minutes

---

## 🎯 Find Information By Topic

### Getting Started
- **What is OTA?** → [README.md](README.md#what-is-ota)
- **Quick setup** → [QUICKSTART.md](QUICKSTART.md)
- **What to do after clone** → [NEXT_STEPS.md](NEXT_STEPS.md)

### Configuration
- **eas.json explained** → [SETUP_SUMMARY.md](SETUP_SUMMARY.md#core-configuration-files)
- **app.json settings** → [OTA_GUIDE.md](OTA_GUIDE.md#configuration-explanation)
- **Environment variables** → [ENV_SETUP.md](ENV_SETUP.md)

### GitHub Actions / CI/CD
- **How workflows work** → [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#cicd-pipeline-architecture)
- **Setup EXPO_TOKEN** → [ENV_SETUP.md](ENV_SETUP.md#expo_token-required)
- **Workflow configuration** → [SETUP_SUMMARY.md](SETUP_SUMMARY.md#cicd-workflows)

### Deployment
- **Deploy OTA update** → [QUICKSTART.md](QUICKSTART.md#deploy-ota-update)
- **Manual vs Auto deploy** → [OTA_GUIDE.md](OTA_GUIDE.md#deploy-ota-updates)
- **Build initial app** → [NEXT_STEPS.md](NEXT_STEPS.md#step-3-build-app-lần-đầu)

### Testing
- **Test OTA on device** → [QUICKSTART.md](QUICKSTART.md#test-update-trên-device)
- **In-app testing** → [OTA_GUIDE.md](OTA_GUIDE.md#testing)
- **Verify workflow** → [OTA_CHECKLIST.md](OTA_CHECKLIST.md#test-ota-update-flow)

### Workflows & Architecture
- **Complete flow diagram** → [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md)
- **Branch strategy** → [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#branch-strategy-flow)
- **Runtime version matching** → [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#runtime-version-matching)

### Troubleshooting
- **Common issues** → [OTA_GUIDE.md](OTA_GUIDE.md#troubleshooting)
- **No updates available** → [OTA_GUIDE.md](OTA_GUIDE.md#1-updates-không-được-nhận)
- **GitHub Actions failed** → [OTA_GUIDE.md](OTA_GUIDE.md#2-build-failed-trên-github-actions)
- **Runtime mismatch** → [OTA_GUIDE.md](OTA_GUIDE.md#4-runtime-version-mismatch)

### Best Practices
- **Development workflow** → [OTA_GUIDE.md](OTA_GUIDE.md#best-practices)
- **Security practices** → [ENV_SETUP.md](ENV_SETUP.md#security-best-practices)
- **Monitoring & rollback** → [OTA_GUIDE.md](OTA_GUIDE.md#5-monitor-updates)

### Commands Reference
- **Essential commands** → [QUICKSTART.md](QUICKSTART.md#useful-commands)
- **All commands** → [OTA_GUIDE.md](OTA_GUIDE.md#useful-commands)
- **Helper script** → [NEXT_STEPS.md](NEXT_STEPS.md#helper-commands)

---

## 🔍 Search by Keyword

| Keyword | Location |
|---------|----------|
| **EXPO_TOKEN** | [ENV_SETUP.md](ENV_SETUP.md#expo_token-required) |
| **eas.json** | [SETUP_SUMMARY.md](SETUP_SUMMARY.md#easjson) |
| **runtimeVersion** | [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#runtime-version-matching) |
| **GitHub Actions** | [SETUP_SUMMARY.md](SETUP_SUMMARY.md#github-actions-workflows) |
| **channel** | [OTA_GUIDE.md](OTA_GUIDE.md#update-channels) |
| **rollback** | [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#rollback-flow) |
| **build** | [NEXT_STEPS.md](NEXT_STEPS.md#step-3-build-app-lần-đầu) |
| **deploy** | [QUICKSTART.md](QUICKSTART.md#deploy-ota-update) |
| **test** | [OTA_CHECKLIST.md](OTA_CHECKLIST.md#test-ota-update-flow) |
| **troubleshoot** | [OTA_GUIDE.md](OTA_GUIDE.md#troubleshooting) |

---

## 📱 Component Documentation

### React Components

| Component | File | Description |
|-----------|------|-------------|
| **OtaUpdateManager** | `/ota-v2/components/ota-update-manager.tsx` | In-app UI for testing OTA updates |
| **Home Screen** | `/ota-v2/app/(tabs)/index.tsx` | Integrated OTA manager |

### Scripts

| Script | File | Description |
|--------|------|-------------|
| **OTA Helper** | `/scripts/ota-helper.sh` | Interactive CLI for OTA management |

### Workflows

| Workflow | File | Description |
|----------|------|-------------|
| **OTA Update** | `/.github/workflows/ota-update.yml` | Auto deploy OTA on push |
| **EAS Build** | `/.github/workflows/eas-build.yml` | Manual app builds |

---

## 🎓 Learning Resources

### Internal Documentation
1. **[OTA_GUIDE.md](OTA_GUIDE.md)** - Complete guide with examples
2. **[WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md)** - Visual learning
3. **[OTA_CHECKLIST.md](OTA_CHECKLIST.md)** - Hands-on practice

### External Resources
- [Expo Updates Docs](https://docs.expo.dev/eas-update/introduction/)
- [EAS Build Docs](https://docs.expo.dev/build/introduction/)
- [GitHub Actions for Expo](https://docs.expo.dev/build/building-on-ci/)
- [Expo Router](https://docs.expo.dev/router/introduction/)

---

## 💡 Quick Tips

### 🚀 Deploy OTA in 3 commands
```bash
cd ota-v2
git add . && git commit -m "feat: update"
git push origin develop
```

### 🛠️ Use helper script
```bash
./scripts/ota-helper.sh
```

### 📊 Monitor updates
https://expo.dev → Your project → Updates

### 🔄 Quick rollback
```bash
eas update:list --branch production
eas update:republish --group [OLD_GROUP_ID]
```

---

## ❓ FAQ Navigation

| Question | Answer Location |
|----------|-----------------|
| What is OTA? | [README.md](README.md#what-is-ota) |
| How to setup? | [QUICKSTART.md](QUICKSTART.md) |
| How to deploy? | [QUICKSTART.md](QUICKSTART.md#deploy-ota-update) |
| How to test? | [OTA_CHECKLIST.md](OTA_CHECKLIST.md#test-ota-update-flow) |
| Updates not working? | [OTA_GUIDE.md](OTA_GUIDE.md#troubleshooting) |
| How to rollback? | [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#rollback-flow) |
| What can OTA update? | [README.md](README.md#what-is-ota) |
| Build vs Update? | [WORKFLOW_DIAGRAM.md](WORKFLOW_DIAGRAM.md#build-vs-update-flow) |

---

## 🔗 External Links

- **GitHub Repository:** https://github.com/hieuminhnguyen1810-sudo/OTA_TEST_V2
- **Expo Dashboard:** https://expo.dev
- **Expo Documentation:** https://docs.expo.dev
- **EAS Update Guide:** https://docs.expo.dev/eas-update/introduction/

---

## 📞 Need Help?

1. **Search this index** for your topic
2. **Read relevant documentation** from links above
3. **Check troubleshooting** in [OTA_GUIDE.md](OTA_GUIDE.md#troubleshooting)
4. **Open GitHub Issue** if still stuck
5. **Ask on Expo Discord:** https://chat.expo.dev

---

<div align="center">

**📚 Documentation Version 1.0**

Made with ❤️

[Back to README](README.md)

</div>


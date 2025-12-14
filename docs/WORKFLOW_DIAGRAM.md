# 🔄 OTA Workflow Diagram

## 📊 Complete OTA Update Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DEVELOPER WORKFLOW                          │
└─────────────────────────────────────────────────────────────────────┘

1. LOCAL DEVELOPMENT
   ┌──────────────┐
   │ Write Code   │
   │ Make Changes │
   └──────┬───────┘
          │
          ↓
2. GIT COMMIT & PUSH
   ┌───────────────────────────────────────┐
   │  git add .                            │
   │  git commit -m "feat: new feature"   │
   │  git push origin [branch]            │
   └───────────────┬───────────────────────┘
                   │
                   ↓
┌──────────────────────────────────────────────────────────────────────┐
│                         GITHUB ACTIONS                               │
└──────────────────────────────────────────────────────────────────────┘

3. AUTO DETECT BRANCH
   ┌─────────────────────────────────────────┐
   │  Push to main      → production channel │
   │  Push to develop   → preview channel    │
   │  Push to feature/* → development channel│
   └─────────────────┬───────────────────────┘
                     │
                     ↓
4. RUN WORKFLOW (.github/workflows/ota-update.yml)
   ┌────────────────────────────────────┐
   │ ✓ Checkout code                    │
   │ ✓ Setup Node.js                    │
   │ ✓ Setup Expo (using EXPO_TOKEN)    │
   │ ✓ Install dependencies             │
   │ ✓ Determine channel & message      │
   │ ✓ Run: eas update --branch [channel]│
   └────────────────┬───────────────────┘
                    │
                    ↓
5. PUBLISH TO EXPO CDN
   ┌─────────────────────────────────┐
   │  JavaScript bundle uploaded     │
   │  Assets (images, fonts) uploaded│
   │  Manifest created               │
   │  Update available on channel    │
   └────────────────┬────────────────┘
                    │
                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│                         USER DEVICE (APP)                            │
└──────────────────────────────────────────────────────────────────────┘

6. APP LAUNCH / RELAUNCH
   ┌────────────────────────────────┐
   │  User opens app                │
   │  OR User force quit & reopen   │
   └────────────────┬───────────────┘
                    │
                    ↓
7. CHECK FOR UPDATES (Automatic)
   ┌──────────────────────────────────────┐
   │  expo-updates checks CDN             │
   │  Compare: Runtime Version            │
   │  Compare: Current Update ID          │
   │  Compare: Channel                    │
   └────────────────┬─────────────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
         ↓ No Update          ↓ Update Available
   ┌─────────────┐      ┌──────────────────┐
   │ Run Current │      │ Download Update  │
   │ Version     │      │ in Background    │
   └─────────────┘      └────────┬─────────┘
                                 │
                                 ↓
                        8. APPLY UPDATE
                        ┌─────────────────────┐
                        │ Next app restart:   │
                        │ - Load new JS bundle│
                        │ - Load new assets   │
                        │ - Update applied! ✅│
                        └─────────────────────┘
```

---

## 🔀 Branch Strategy Flow

```
┌──────────────────────────────────────────────────────────────┐
│                    BRANCHING WORKFLOW                        │
└──────────────────────────────────────────────────────────────┘

feature/my-feature (development channel)
    │
    │ git checkout develop
    │ git merge feature/my-feature
    ↓
develop (preview channel) ← QA & Beta Testing
    │
    │ git checkout main
    │ git merge develop
    ↓
main (production channel) ← Production Users


CHANNEL MAPPING:
┌───────────────┬──────────────┬─────────────────────┐
│ Git Branch    │ OTA Channel  │ Purpose             │
├───────────────┼──────────────┼─────────────────────┤
│ feature/*     │ development  │ Dev & Local Testing │
│ develop       │ preview      │ QA & Beta Testing   │
│ main          │ production   │ Production Users    │
└───────────────┴──────────────┴─────────────────────┘
```

---

## 🏗️ Build vs Update Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                 WHEN TO BUILD vs UPDATE                         │
└─────────────────────────────────────────────────────────────────┘

NATIVE CHANGES → REQUIRES NEW BUILD
┌────────────────────────────────────────┐
│ • New native dependencies              │
│ • Native code changes (Java/Kotlin)    │
│ • New permissions                      │
│ • Config changes (AndroidManifest.xml) │
│ • Expo SDK upgrade                     │
│ • Change runtime version               │
└────────────────┬───────────────────────┘
                 │
                 ↓
         EAS BUILD (15-20 min)
         eas build --platform android
                 │
                 ↓
         PUBLISH TO STORE
         - Google Play Store
         - Apple App Store
                 │
                 ↓
         USERS MUST UPDATE FROM STORE


JAVASCRIPT CHANGES → OTA UPDATE
┌────────────────────────────────────────┐
│ • JavaScript/TypeScript code           │
│ • React components                     │
│ • Business logic                       │
│ • UI changes                           │
│ • Images, fonts, assets                │
│ • Styling (CSS)                        │
└────────────────┬───────────────────────┘
                 │
                 ↓
         OTA UPDATE (30 seconds)
         eas update --branch preview
                 │
                 ↓
         PUBLISH TO EXPO CDN
         Instant delivery
                 │
                 ↓
         USERS AUTO RECEIVE UPDATE
         (on next app launch)
```

---

## 🚀 CI/CD Pipeline Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                      GITHUB ACTIONS PIPELINE                       │
└────────────────────────────────────────────────────────────────────┘

TRIGGER: Push to Repository
    │
    ├─────────────────┬────────────────────┐
    │                 │                    │
    ↓                 ↓                    ↓
┌────────┐      ┌──────────┐      ┌──────────────┐
│  main  │      │ develop  │      │  feature/*   │
└───┬────┘      └────┬─────┘      └──────┬───────┘
    │                │                   │
    ↓                ↓                   ↓
┌─────────────────────────────────────────────────┐
│    .github/workflows/ota-update.yml             │
│                                                 │
│  jobs:                                          │
│    update:                                      │
│      - Checkout code                            │
│      - Setup Node.js 20.x                       │
│      - Setup Expo & EAS                         │
│      - npm ci                                   │
│      - Determine channel (main/develop/other)   │
│      - eas update --branch [channel]            │
│      - Post summary                             │
└───────────────────┬─────────────────────────────┘
                    │
                    ↓
            ┌───────────────┐
            │  EXPO CDN     │
            │  Updates Hosted│
            └───────┬───────┘
                    │
                    ↓
            ┌───────────────┐
            │  User Devices │
            │  Auto Download│
            └───────────────┘


MANUAL TRIGGER: GitHub Actions UI
    │
    ↓
┌──────────────────────────────────────┐
│  Workflow Dispatch                   │
│  - Select Channel                    │
│  - Enter Update Message              │
│  - Run Workflow                      │
└──────────────────┬───────────────────┘
                   │
                   ↓
          Same flow as above
```

---

## 📱 Runtime Version Matching

```
┌───────────────────────────────────────────────────────────────┐
│               RUNTIME VERSION COMPATIBILITY                   │
└───────────────────────────────────────────────────────────────┘

APP BUILD (v1.0.0, SDK 54)
    │ runtimeVersion: "54.0.0"
    │
    ↓
PUBLISHED TO STORE
    │
    ↓
USER INSTALLS APP
    │ Runtime: 54.0.0
    │
    ├─────────────────┬────────────────────┐
    │                 │                    │
    ↓ Match ✅        ↓ Match ✅          ↓ No Match ❌
OTA Update v1       OTA Update v2       OTA Update v3
Runtime: 54.0.0     Runtime: 54.0.0     Runtime: 55.0.0
    │                   │                    │
    ↓                   ↓                    ↓
COMPATIBLE          COMPATIBLE          INCOMPATIBLE
User receives       User receives       User won't receive
update ✅           update ✅           (needs app rebuild) ❌


POLICY OPTIONS in app.json:
┌────────────────┬──────────────────────────────────────┐
│ Policy         │ Description                          │
├────────────────┼──────────────────────────────────────┤
│ sdkVersion     │ Use Expo SDK version (e.g. "54.0.0") │
│ appVersion     │ Use app version (e.g. "1.0.0")       │
│ nativeVersion  │ Use native build number              │
│ custom         │ Define your own versioning logic     │
└────────────────┴──────────────────────────────────────┘
```

---

## 🔄 Rollback Flow

```
┌──────────────────────────────────────────────────────────┐
│                    ROLLBACK SCENARIO                     │
└──────────────────────────────────────────────────────────┘

CURRENT STATE: Update v3 has bug 🐛
    │
    ↓
DEVELOPER NOTICES ISSUE
    │
    ↓
┌────────────────────────────┐
│ Option 1: Quick Fix        │
│ eas update --branch prod   │
│ (Deploy new fixed version) │
└────────────┬───────────────┘
             │
             OR
             │
┌────────────────────────────┐
│ Option 2: Rollback         │
│                            │
│ 1. eas update:list         │
│    --branch production     │
│                            │
│ 2. Find previous good      │
│    update (v2) group ID    │
│                            │
│ 3. eas update:republish    │
│    --group [v2-group-id]   │
└────────────┬───────────────┘
             │
             ↓
    PREVIOUS VERSION RE-PUBLISHED
             │
             ↓
    USERS GET v2 ON NEXT LAUNCH
             │
             ↓
         ISSUE RESOLVED ✅


TIMELINE:
┌────────┬────────┬────────┬────────┬────────┐
│ v1     │ v2     │ v3     │ v2     │ v4     │
│ (good) │ (good) │ (bug!) │(rolled)│ (fix)  │
│        │        │        │ back   │        │
└────────┴────────┴────────┴────────┴────────┘
  Deploy   Deploy   Deploy   Rollback  Deploy
                    ↓                    ↑
                    Problem found        Fixed
```

---

## 🔐 Security & Token Flow

```
┌──────────────────────────────────────────────────────────┐
│                  AUTHENTICATION FLOW                     │
└──────────────────────────────────────────────────────────┘

DEVELOPER
    │ eas login
    │ eas token:create
    ↓
EXPO_TOKEN generated
    │
    ├──────────────────┬──────────────────┐
    │                  │                  │
    ↓                  ↓                  ↓
LOCAL MACHINE    GITHUB SECRETS    EAS SERVERS
~/.expo/         Repository        Authentication
state.json       Settings          Service
    │                  │                  │
    ↓                  ↓                  ↓
Local CLI        GitHub Actions    Validate Token
Commands         Workflows         & Permissions
    │                  │                  │
    └──────────────────┴─────────┬────────┘
                                 │
                                 ↓
                    AUTHORIZED OPERATIONS
                    - eas build
                    - eas update
                    - eas submit


SECURITY BEST PRACTICES:
┌────────────────────────────────────────────────────┐
│ ✓ Never commit token to git                       │
│ ✓ Use GitHub Secrets for CI/CD                    │
│ ✓ Rotate tokens periodically                      │
│ ✓ Use different tokens for dev vs CI/CD           │
│ ✓ Limit token scope/permissions                   │
│ ✓ Revoke old/unused tokens                        │
└────────────────────────────────────────────────────┘
```

---

## 📊 Monitoring & Analytics Flow

```
┌──────────────────────────────────────────────────────────┐
│                    MONITORING FLOW                       │
└──────────────────────────────────────────────────────────┘

UPDATE DEPLOYED
    │
    ↓
EXPO CDN Hosting
    │
    ├──────────────────┬──────────────────┐
    │                  │                  │
    ↓                  ↓                  ↓
User Device 1    User Device 2    User Device N
Downloads        Downloads        Downloads
    │                  │                  │
    └──────────────────┴─────────┬────────┘
                                 │
                                 ↓
                    EXPO ANALYTICS DASHBOARD
                    https://expo.dev
                            │
                            ↓
            ┌───────────────────────────────┐
            │ Metrics Tracked:              │
            │ • Total downloads             │
            │ • Success rate                │
            │ • Failure rate                │
            │ • Active users                │
            │ • Update adoption rate        │
            │ • Platform breakdown          │
            │ • Crash reports               │
            └───────────────┬───────────────┘
                            │
                            ↓
                    DEVELOPER DASHBOARD
                    Monitor & Analyze
                            │
                            ↓
            ┌───────────────────────────────┐
            │ Actions:                      │
            │ • View update performance     │
            │ • Identify issues             │
            │ • Rollback if needed          │
            │ • Deploy fixes                │
            └───────────────────────────────┘
```

---

## 🎯 Complete Development Lifecycle

```
┌────────────────────────────────────────────────────────────────┐
│           END-TO-END DEVELOPMENT LIFECYCLE                     │
└────────────────────────────────────────────────────────────────┘

PHASE 1: INITIAL SETUP (One-time)
    ┌─────────────────────────────────────┐
    │ 1. Create Expo project              │
    │ 2. Configure eas.json & app.json    │
    │ 3. Setup GitHub Actions workflows   │
    │ 4. Add EXPO_TOKEN to GitHub Secrets │
    │ 5. Initial EAS build                │
    └──────────────────┬──────────────────┘
                       ↓

PHASE 2: DEVELOPMENT CYCLE (Recurring)
    ┌─────────────────────────────────────┐
    │ 1. Write code                       │
    │ 2. Test locally                     │
    │ 3. Commit & push to feature branch  │
    │ 4. Deploy to development channel    │
    │ 5. Internal testing                 │
    └──────────────────┬──────────────────┘
                       ↓

PHASE 3: QA CYCLE (Recurring)
    ┌─────────────────────────────────────┐
    │ 1. Merge to develop branch          │
    │ 2. Auto deploy to preview channel   │
    │ 3. QA testing                       │
    │ 4. Bug fixes (back to Phase 2)      │
    │ 5. QA approval                      │
    └──────────────────┬──────────────────┘
                       ↓

PHASE 4: PRODUCTION RELEASE (Recurring)
    ┌─────────────────────────────────────┐
    │ 1. Merge to main branch             │
    │ 2. Auto deploy to production channel│
    │ 3. Monitor analytics                │
    │ 4. User feedback                    │
    │ 5. Hotfixes if needed               │
    └──────────────────┬──────────────────┘
                       ↓

PHASE 5: MAINTENANCE (Ongoing)
    ┌─────────────────────────────────────┐
    │ • Monitor update adoption           │
    │ • Track crash reports               │
    │ • Rollback if critical issues       │
    │ • Plan next iteration               │
    └─────────────────────────────────────┘
         │
         └──────→ Back to PHASE 2 ──┐
                                     │
                                Loop ↻
```

---

**📖 For detailed implementation, see:**
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [OTA_GUIDE.md](OTA_GUIDE.md) - Complete documentation
- [OTA_CHECKLIST.md](OTA_CHECKLIST.md) - Step-by-step checklist


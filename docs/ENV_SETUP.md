# Environment Variables

## GitHub Secrets (Required)

Các secrets này cần được thêm vào GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

### EXPO_TOKEN (Required)
Token để authenticate với EAS trong GitHub Actions

**Cách lấy token:**

```bash
# Method 1: From EAS CLI
eas login
eas whoami

# Your token is stored in ~/.expo/state.json
# Or create a new token:
eas token:create
```

**Hoặc:**

1. Vào https://expo.dev
2. Account Settings → Access Tokens
3. Create new token
4. Copy và paste vào GitHub Secrets

---

## Local Development (.env) - Optional

Nếu bạn muốn dùng environment variables trong app:

### Cài đặt

```bash
npm install --save react-native-dotenv
npm install --save-dev @types/react-native-dotenv
```

### Tạo file .env

```bash
# .env.development
EXPO_PUBLIC_API_URL=https://dev-api.example.com
EXPO_PUBLIC_ENV=development

# .env.preview
EXPO_PUBLIC_API_URL=https://staging-api.example.com
EXPO_PUBLIC_ENV=preview

# .env.production
EXPO_PUBLIC_API_URL=https://api.example.com
EXPO_PUBLIC_ENV=production
```

### Sử dụng trong code

```typescript
// app/config.ts
export const config = {
  apiUrl: process.env.EXPO_PUBLIC_API_URL,
  environment: process.env.EXPO_PUBLIC_ENV,
};
```

**Lưu ý:** 
- Các biến phải bắt đầu với `EXPO_PUBLIC_` để accessible trong app
- Thêm `.env*` vào `.gitignore`
- Commit file `.env.example` để team biết cần variables gì

---

## EAS Build Secrets (Optional)

Nếu cần secrets cho build process (API keys, signing credentials, etc.)

### Thêm secrets cho EAS Build

```bash
# Add secret
eas secret:create --scope project --name MY_SECRET --value "secret_value"

# List secrets
eas secret:list

# Delete secret
eas secret:delete --name MY_SECRET
```

### Sử dụng trong eas.json

```json
{
  "build": {
    "production": {
      "env": {
        "MY_SECRET": "$(MY_SECRET)"
      }
    }
  }
}
```

---

## Verification

### Check EXPO_TOKEN on GitHub

```bash
# Test workflow có access đến secret không
# Xem logs của GitHub Actions workflow
# Nếu thấy error "EXPO_TOKEN is not set", check lại secrets
```

### Check local EAS authentication

```bash
eas whoami
# Should show your Expo username

# If not logged in:
eas login
```

---

## Security Best Practices

1. **NEVER commit tokens/secrets to git**
   - Add to `.gitignore`: `.env`, `.env.*`, `!.env.example`

2. **Rotate tokens định kỳ**
   ```bash
   # Delete old token
   eas token:delete
   
   # Create new token
   eas token:create
   
   # Update GitHub Secrets
   ```

3. **Use different tokens cho CI/CD vs local development**
   - CI/CD: Token với minimal permissions
   - Local: Personal token

4. **Limit token scope**
   - Chỉ grant permissions cần thiết
   - Use project-specific tokens nếu có thể

---

## Common Issues

### "Authentication failed" in GitHub Actions

**Solution:**
1. Verify EXPO_TOKEN is set in GitHub Secrets
2. Token còn valid không (check expiry)
3. Re-generate token và update secret

### "Permission denied" 

**Solution:**
1. Token phải có quyền publish updates
2. User phải có quyền trên Expo project
3. Check project ownership: `eas project:info`

### Local build works but CI/CD fails

**Solution:**
1. Verify token in CI/CD khác với local token
2. Check token permissions
3. Verify project ID trong app.json match với token's account


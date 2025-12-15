/**
 * Branch-based config loader.
 * - Detects current branch (from GITHUB_REF_NAME or git)
 * - Maps branch name to a config file in config/
 * - Falls back to main.json if mapping not found
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Map branch -> config file
// BẮT BUỘC KHAI BÁO CHO MỖI BRANCH, KHÔNG FALLBACK
const BRANCH_CONFIG_MAP = {
  bv_app1: 'bv_app1.json',
  // Thêm tại đây cho mỗi branch
  // bv_app2: 'bv_app2.json',
  // bv_app3: 'bv_app3.json',
  // ...
};

function getCurrentBranch() {
  // Prefer GitHub Actions env
  if (process.env.GITHUB_REF_NAME) return process.env.GITHUB_REF_NAME;

  // Fallback: try git
  try {
    return execSync('git rev-parse --abbrev-ref HEAD', { encoding: 'utf-8' }).trim();
  } catch (_err) {
    return 'main';
  }
}

function getConfigPath(branch) {
  const fileName = BRANCH_CONFIG_MAP[branch];
  if (!fileName) {
    throw new Error(
      `No config mapping for branch "${branch}". Please add it to BRANCH_CONFIG_MAP in config/index.js`
    );
  }

  const configPath = path.join(__dirname, fileName);
  if (!fs.existsSync(configPath)) {
    throw new Error(`Config file not found for branch "${branch}": ${configPath}`);
  }
  return configPath;
}

const branch = getCurrentBranch();
const configPath = getConfigPath(branch);
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

// Avoid noisy logs in CI
if (process.env.CI !== 'true') {
  console.log(`📦 Loading config for branch: ${branch}`);
  console.log(`   Config file: ${path.basename(configPath)}`);
  console.log(`   App: ${config.appName}`);
}

module.exports = config;


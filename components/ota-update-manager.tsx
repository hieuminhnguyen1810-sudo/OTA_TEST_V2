import { View, Text, Button, Alert, ActivityIndicator, StyleSheet } from 'react-native';
import * as Updates from 'expo-updates';
import { useState, useEffect } from 'react';

/**
 * OTA Update Manager Component
 * Hiển thị thông tin update và cho phép user check/apply updates manually
 */
export function OtaUpdateManager() {
  const [isChecking, setIsChecking] = useState(false);
  const [isDownloading, setIsDownloading] = useState(false);
  const [updateInfo, setUpdateInfo] = useState<{
    currentlyRunning: string;
    channel: string | null;
    runtimeVersion: string | null;
  } | null>(null);

  useEffect(() => {
    loadUpdateInfo();
  }, []);

  const loadUpdateInfo = () => {
    try {
      const info = {
        currentlyRunning: Updates.updateId || 'Development',
        channel: Updates.channel || 'N/A',
        runtimeVersion: Updates.runtimeVersion || 'N/A',
      };
      setUpdateInfo(info);
    } catch (error) {
      console.error('Error loading update info:', error);
    }
  };

  const checkForUpdates = async () => {
    try {
      setIsChecking(true);

      // Check if running in development
      if (__DEV__) {
        Alert.alert(
          'Development Mode',
          'OTA updates không hoạt động trong development mode. Build app với EAS để test.'
        );
        setIsChecking(false);
        return;
      }

      const update = await Updates.checkForUpdateAsync();

      if (update.isAvailable) {
        Alert.alert(
          'Update Available',
          'Có bản update mới. Bạn có muốn tải về không?',
          [
            {
              text: 'Để sau',
              style: 'cancel',
              onPress: () => setIsChecking(false),
            },
            {
              text: 'Tải ngay',
              onPress: () => downloadUpdate(),
            },
          ]
        );
      } else {
        Alert.alert(
          'No Updates',
          'App đang ở phiên bản mới nhất!',
          [{ text: 'OK', onPress: () => setIsChecking(false) }]
        );
      }
    } catch (error) {
      console.error('Error checking for updates:', error);
      Alert.alert(
        'Error',
        `Không thể check update: ${error instanceof Error ? error.message : 'Unknown error'}`,
        [{ text: 'OK', onPress: () => setIsChecking(false) }]
      );
    }
  };

  const downloadUpdate = async () => {
    try {
      setIsChecking(false);
      setIsDownloading(true);

      await Updates.fetchUpdateAsync();

      Alert.alert(
        'Update Downloaded',
        'Update đã được tải về. Restart app để áp dụng?',
        [
          {
            text: 'Để sau',
            style: 'cancel',
            onPress: () => setIsDownloading(false),
          },
          {
            text: 'Restart ngay',
            onPress: async () => {
              await Updates.reloadAsync();
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error downloading update:', error);
      Alert.alert(
        'Error',
        `Không thể tải update: ${error instanceof Error ? error.message : 'Unknown error'}`,
        [{ text: 'OK', onPress: () => setIsDownloading(false) }]
      );
    }
  };

  const forceReload = async () => {
    try {
      await Updates.reloadAsync();
    } catch (error) {
      console.error('Error reloading:', error);
      Alert.alert('Error', 'Không thể restart app');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>🔄 OTA Update Manager</Text>

      {updateInfo && (
        <View style={styles.infoContainer}>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Update ID:</Text>
            <Text style={styles.infoValue} numberOfLines={1}>
              {updateInfo.currentlyRunning}
            </Text>
          </View>

          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Channel:</Text>
            <Text style={styles.infoValue}>{updateInfo.channel}</Text>
          </View>

          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Runtime Version:</Text>
            <Text style={styles.infoValue}>{updateInfo.runtimeVersion}</Text>
          </View>
        </View>
      )}

      <View style={styles.buttonContainer}>
        <Button
          title={isChecking ? 'Đang kiểm tra...' : 'Check for Updates'}
          onPress={checkForUpdates}
          disabled={isChecking || isDownloading}
        />

        {isChecking && <ActivityIndicator style={styles.loader} />}
        {isDownloading && (
          <View style={styles.downloadingContainer}>
            <ActivityIndicator />
            <Text style={styles.downloadingText}>Đang tải update...</Text>
          </View>
        )}

        <View style={styles.spacer} />

        <Button
          title="Force Reload"
          onPress={forceReload}
          disabled={isChecking || isDownloading}
          color="#FF6B6B"
        />
      </View>

      <Text style={styles.hint}>
        💡 Tip: Sau khi deploy OTA update, force quit app và mở lại để nhận update tự động
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 20,
    backgroundColor: '#f5f5f5',
    borderRadius: 12,
    marginVertical: 10,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 16,
    textAlign: 'center',
  },
  infoContainer: {
    backgroundColor: 'white',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 6,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  infoLabel: {
    fontWeight: '600',
    color: '#666',
    flex: 1,
  },
  infoValue: {
    color: '#333',
    flex: 2,
    textAlign: 'right',
  },
  buttonContainer: {
    gap: 12,
  },
  spacer: {
    height: 8,
  },
  loader: {
    marginVertical: 8,
  },
  downloadingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    paddingVertical: 8,
  },
  downloadingText: {
    color: '#666',
  },
  hint: {
    marginTop: 16,
    fontSize: 12,
    color: '#666',
    fontStyle: 'italic',
    textAlign: 'center',
  },
});


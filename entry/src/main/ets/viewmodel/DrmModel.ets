import drm from '@ohos.multimedia.drm';
import { BusinessError } from '@ohos.base';

export function bytesToHex(bytes: Uint8Array): string {
  return Array.from(bytes).map((b: number) => b.toString(16).padStart(2, '0')).join('');
}

export class DrmModel {
  /**
   * 通过isMediaKeySystemSupported方法，查询设备是否支持对应的插件类型。
   * @param name
   * @param mimeType
   * @param level
   * @returns
   */
  public isMediaKeySystemSupported(name: string, mimeType: string, level: drm.ContentProtectionLevel): boolean {
    let isSupported = drm.isMediaKeySystemSupported(name);
    isSupported = drm.isMediaKeySystemSupported(name, mimeType);
    isSupported = drm.isMediaKeySystemSupported(name, mimeType, level);
    return isSupported;
  }

  public isMediaKeySystemSupported1(name: string): boolean {
    let isSupported = drm.isMediaKeySystemSupported(name);
    return isSupported;
  }

  /**
   * 通过drm的createMediaKeySystem(name: string)方法，创建MediaKeySystem实例，同步返回结果，创建失败，不可继续后续操作。
   * @param name
   * @returns
   */
  public createMediaKeySystem(name: string): drm.MediaKeySystem {
    let mediaKeySystem: drm.MediaKeySystem = drm.createMediaKeySystem(name);
    return mediaKeySystem;
  }

  /**
   * 通过getMediaKeySystems方法，获取设备支持对应的插件类型的name和uuid。
   * @returns
   */
  public getMediaKeySystems(): drm.MediaKeySystemDescription[] {
    let description: drm.MediaKeySystemDescription[] = [];
    try {
      description = drm.getMediaKeySystems();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getMediaKeySystems ERROR: ${error}`)
    }
    return description;
  }

  /**
   * 通过getMediaKeySystemUuid方法，获取设备支持对应的插件类型的uuid。
   * @param name
   * @returns
   */
  public getMediaKeySystemUuid(name: string): string {
    let uuid = ''
    try {
      //uuid = drm.getMediaKeySystemUuid(name);
      const list = drm.getMediaKeySystems()
      for (let i = 0; i < list.length; i++) {
        const element = list[i]
        const name = element.name
        const uuid = element.uuid
      }
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getMediaKeySystems ERROR: ${error}`)
    }
    return uuid
  }

  /**
   * 获取离线许可证Id
   * @returns
   */
  public getOfflineMediaKeyIds(): Uint8Array[] | undefined {
    let mediaKeysystem: drm.MediaKeySystem = drm.createMediaKeySystem("com.wiseplay.drm");
    let offlineMediaKeyIds: Uint8Array[] | undefined = undefined;
    try {
      offlineMediaKeyIds = mediaKeysystem.getOfflineMediaKeyIds();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getOfflineMediaKeyIds ERROR: ${error}`);
    }
    return offlineMediaKeyIds;
  }

  public getDeviceUniqueId(): string {
    let deviceUniqueId = ''
    let mediaKeySystem: drm.MediaKeySystem = drm.createMediaKeySystem("com.wiseplay.drm");
    try {
      let deviceUniqueIdBytes: Uint8Array =
        mediaKeySystem.getConfigurationByteArray("deviceUniqueId"); // 确保deviceUniqueId属性是存在的
      deviceUniqueId = bytesToHex(deviceUniqueIdBytes)
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getConfigurationByteArray ERROR: ${error}`);
    }
    return deviceUniqueId
  }

  public getMaxContentProtectionLevel(): number {
    let contentProtectionLevel: drm.ContentProtectionLevel =
      drm.ContentProtectionLevel.CONTENT_PROTECTION_LEVEL_UNKNOWN;
    let mediaKeySystem: drm.MediaKeySystem = drm.createMediaKeySystem("com.wiseplay.drm");
    try {
      contentProtectionLevel = mediaKeySystem.getMaxContentProtectionLevel();
      return contentProtectionLevel
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getMaxContentProtectionLevel ERROR: ${error}`);
    }
    return -1
  }

  public getContentProtectionLevel(): number {
    let mediaKeySystem: drm.MediaKeySystem = drm.createMediaKeySystem("com.wiseplay.drm");
    let mediaKeySession: drm.MediaKeySession = mediaKeySystem.createMediaKeySession();
    try {
      let contentProtectionLevel: drm.ContentProtectionLevel = mediaKeySession.getContentProtectionLevel();
      return contentProtectionLevel
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getContentProtectionLevel ERROR: ${error}`);
    }
    return -1
  }
}


export default new DrmModel()
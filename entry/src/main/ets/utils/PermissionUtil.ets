import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import bundleManager from '@ohos.bundle.bundleManager';
import { Logger } from './Log';


export class PermissionUtil {
  private static readonly TAG = 'PermissionUtil'

  ///检查是否具有权限
  public static checkPermissions(permission: Permissions): boolean {
    let grantStatus: abilityAccessCtrl.GrantStatus = PermissionUtil.hasPms(permission)
    return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED ? true : false
  }

  public static hasPms(permission: Permissions): abilityAccessCtrl.GrantStatus {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    // 校验应用是否被授予权限
    try {
      // 获取应用程序的accessTokenID
      const bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
      const tokenId = appInfo.accessTokenId
      grantStatus = atManager.checkAccessTokenSync(tokenId, permission)
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(PermissionUtil.TAG, `Failed to check access token. Code is ${err.code}, message is ${err.message}`)
    }
    return grantStatus
  }

  public static async requestPermissionsFromUser(context: Context, permission: Permissions): Promise<boolean> {
    return await new Promise((resolve: Function, reject: Function) => {
      try {
        const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
        atManager.requestPermissionsFromUser(context, [permission])
          .then((data) => {
            if (data.authResults[0] == 0) {
              //有权限
              resolve(true)
              Logger.debug(PermissionUtil.TAG, `succeeded in requesting permission ${permission}`)
            } else {
              resolve(false)
              Logger.debug(PermissionUtil.TAG, `user rejected ${permission}}`)
            }
          })
      } catch (err) {
        reject(false)
        let error = err as BusinessError
        Logger.error(PermissionUtil.TAG,
          `call requestPermissionsFromUser  ${permission}} failed, error code: ${err.code}, message: ${err.message}.`);
      }
    });

  }
}
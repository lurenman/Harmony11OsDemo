import router from '@ohos.router';
import { Logger } from '../utils/Log';
import { BusinessError } from '@ohos.base'

export class UiUtils {
  static readonly TAG: string = 'UiUtils'

  /**
   * Router page
   *
   * @param {string} url page url
   */
  public routerPage(url: string, params?: Object, mode: number = 0): void {
    if (mode === 0) {
      router.pushUrl({
        url: url,
        params: params
      }).catch((error: BusinessError) => {
        Logger.error(UiUtils.TAG, 'push url error ' + JSON.stringify(error));
      });
    } else {
      router.replaceUrl({
        url: url,
        params: params
      }).catch((error: BusinessError) => {
        Logger.error(UiUtils.TAG, 'replace url error ' + JSON.stringify(error));
      });
    }
  }
}

export default new UiUtils();
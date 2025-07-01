import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import promptAction from '@ohos.promptAction';
import { Lsdk } from '@ohos/staticlibrary';
import { Logger } from '../utils/Log';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'Native_Test'

@Entry
@Component
struct NativePage {
  private mbuffer?: ArrayBuffer
  private mTokenId = ''
  private mblackbox = ''

  @Styles
  bStyle(){
    .width('100%')
    .height('40vp')
    .backgroundColor($r('app.color.login_button_color'))
    .margin({
      top: '30vp',
      bottom: '10vp'
    })
  }

  build() {
    Row() {
      Navigation() {
        Scroll() {
          Column() {
            Button('test')
              .bStyle()
              .onClick(() => {
                const result = Lsdk.add()
                promptAction.showToast({
                  message: `the result:${result}`
                })
              })
            Button('获取ApplicationInfo')
              .bStyle()
              .onClick(() => {
                try {
                  let data = Lsdk.getCurrentApplicationInfo();
                  Logger.debug(TAG, "getCurrentApplicationInfo success, data is " + JSON.stringify(data));
                } catch (err) {
                  let error = err as BusinessError
                  Logger.error(TAG,
                    `call getCurrentApplicationInfo failed, error code: ${err.code}, message: ${err.message}.`);
                }
              })
            Button('kernelVersion')
              .bStyle()
              .onClick(() => {
                try {
                  Lsdk.kernelVersion()
                } catch (err) {
                  let error = err as BusinessError
                  Logger.error(TAG, `call kernelVersion failed, error code: ${err.code}, message: ${err.message}.`);
                }
              })
            Button('threadlist')
              .bStyle()
              .onClick(() => {
                try {
                  Lsdk.getThreadList()
                } catch (err) {
                  let error = err as BusinessError
                  Logger.error(TAG, `call threadlist failed, error code: ${err.code}, message: ${err.message}.`);
                }
              })
          }
          .padding({ left: '20vp', right: '20vp' })
          .width(LAYOUT_WIDTH_OR_HEIGHT)
          .height(LAYOUT_WIDTH_OR_HEIGHT)
          .alignItems(HorizontalAlign.Center)
          .margin({ bottom: '50vp' })
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width(LAYOUT_WIDTH_OR_HEIGHT)
        .height(LAYOUT_WIDTH_OR_HEIGHT)
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('NativePage')
      .titleMode(NavigationTitleMode.Mini)
    }

    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }
}


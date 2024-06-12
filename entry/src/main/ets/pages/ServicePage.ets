import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';

const TAG = 'ServicePage'

@Entry
@Component
struct ServicePage {
  @Styles
  ButtonStyle(){
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
            Button('获取无障碍服务列表')
              .ButtonStyle()
              .onClick(() => {
                let abilityType: accessibility.AbilityType = 'all';
                let abilityState: accessibility.AbilityState = 'enable';
                accessibility.getAccessibilityExtensionList(abilityType, abilityState)
                  .then((data: accessibility.AccessibilityAbilityInfo[]) => {
                    Logger.debug(TAG, `Succeeded in get accessibility extension list, ${JSON.stringify(data)}`)
                  })
                  .catch((err: BusinessError) => {
                    Logger.error(TAG, `failed to get accessibility extension list, Code is ${err.code}, message is ${err.message}`);
                  });
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


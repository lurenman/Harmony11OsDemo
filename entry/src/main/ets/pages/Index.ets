import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import UiUtils from '../utils/UiUtils';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';


@Extend(Button)
function ButtonStyle() {
  .width('100%')
  .height('40vp')
  .backgroundColor($r('app.color.login_button_color'))
  .margin({
    top: '30vp',
    bottom: '10vp'
  })
  .fontSize('16fp')
  .fontWeight(FontWeight.Medium)
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Navigation() {
      Scroll() {
        Column() {
          Button('ui布局')// .id()
            .ButtonStyle()
            .onClick(() => {
              promptAction.showToast({
                message: "正在努力开发中"
              })
            })

          Button('线程相关')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/ThreadPage')
            })

          Button('文件存储')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/FileStoragePage')
            })

          Button('网络请求')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/NetworkPage')
            })

          Button('权限申请')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/PermissionPage')
            })
          Button('设备信息')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/DeviceInfoPage')
            })
          // Button('featureModule')
          //   .ButtonStyle()
          //   .onClick(() => {
          //     //注意context获取位置，运行多feature可以在运行Edit Config中
          //     let want: Want = {
          //       bundleName: 'com.example.harmonyosdemo',
          //       abilityName: 'FeatureAAbility',
          //       moduleName: 'featureA', // moduleName非必选
          //     }
          //     this.context.startAbility(want).then(() => {
          //       console.info('Succeeded in starting ability.');
          //     }).catch((err: BusinessError) => {
          //       console.error(`Failed to start ability. Code is ${err.code}, message is ${err.message}`);
          //     })
          //   })
          Button('加密算法')
            .ButtonStyle()
            .onClick(() => {

            })
          Button('Native相关')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/NativePage')
            })
          Button('服务相关')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/ServicePage')
            })
          Button('setting相关')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/SettingPage')
            })
          Button('window相关')
            .ButtonStyle()
            .onClick(() => {
              UiUtils.routerPage('pages/WindowPage')
            })
        }
        .padding({ left: '20vp', right: '20vp' })
        .width(LAYOUT_WIDTH_OR_HEIGHT)
        //.height(LAYOUT_WIDTH_OR_HEIGHT)
        .alignItems(HorizontalAlign.Center)
        .margin({ bottom: '50vp' })
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .width(LAYOUT_WIDTH_OR_HEIGHT)
      .height(LAYOUT_WIDTH_OR_HEIGHT)
      .onTouch((event) => {
      })
    }
    .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
    .title('demo')
    .titleMode(NavigationTitleMode.Mini)
  }
}

function getObjectKeys(obj: Object) {
  return Object.values(obj);
}
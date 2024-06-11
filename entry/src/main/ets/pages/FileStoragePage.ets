import { LAYOUT_WIDTH_OR_HEIGHT } from '../utils/CommonConstants';
import { Logger } from '../utils/Log';
import { BusinessError } from '@ohos.base';
import data_preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import FileUtils from '../utils/FileUtils';

const TAG = 'FileStoragePage'
let preferences: data_preferences.Preferences | null = null;

@Entry
@Component
struct FileStoragePage {
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
            Button('context路径获取')
              .ButtonStyle()
              .onClick(() => {
                let context: Context = getContext(this) as common.UIAbilityContext;
                let applicationContext = context.getApplicationContext()
                let cacheDir = applicationContext.cacheDir;
                let tempDir = applicationContext.tempDir;
                let filesDir = applicationContext.filesDir;
                let databaseDir = applicationContext.databaseDir;
                let bundleCodeDir = applicationContext.bundleCodeDir;
                let distributedFilesDir = applicationContext.distributedFilesDir;
                let preferencesDir = applicationContext.preferencesDir;
                Logger.debug(TAG, "applicationContext cacheDir:" + cacheDir)
                Logger.debug(TAG, "applicationContext tempDir:" + tempDir)
                Logger.debug(TAG, "applicationContext filesDir:" + filesDir)
                Logger.debug(TAG, "applicationContext databaseDir:" + databaseDir)
                Logger.debug(TAG, "applicationContext bundleCodeDir:" + bundleCodeDir)
                Logger.debug(TAG, "applicationContext distributedFilesDir:" + distributedFilesDir)
                Logger.debug(TAG, "applicationContext preferencesDir:" + preferencesDir)

                let contextcacheDir = context.cacheDir;
                let contexttempDir = context.tempDir;
                let contextfilesDir = context.filesDir;
                let contextdatabaseDir = context.databaseDir;
                let contextbundleCodeDir = context.bundleCodeDir;
                let contextdistributedFilesDir = context.distributedFilesDir;
                let contextpreferencesDir = context.preferencesDir;
                Logger.debug(TAG, "context cacheDir:" + contextcacheDir)
                Logger.debug(TAG, "context tempDir:" + contexttempDir)
                Logger.debug(TAG, "context filesDir:" + contextfilesDir)
                Logger.debug(TAG, "context databaseDir:" + contextdatabaseDir)
                Logger.debug(TAG, "context bundleCodeDir:" + contextbundleCodeDir)
                Logger.debug(TAG, "context distributedFilesDir:" + contextdistributedFilesDir)
                Logger.debug(TAG, "context preferencesDir:" + contextpreferencesDir)


              })
            Button('首选项初始化')
              .ButtonStyle()
              .onClick(() => {
                try {
                  let context: Context = getContext(this) as common.UIAbilityContext;
                  let options: data_preferences.Options = { name: 'myStore' };
                  preferences = data_preferences.getPreferencesSync(context, options);
                  Logger.error(TAG, `preferences getPreferencesSync success`);
                } catch (err) {
                  let code = (err as BusinessError).code;
                  let message = (err as BusinessError).message;
                  Logger.error(TAG, `Failed to get preferences. Code:${code},message:${message}`);
                }
              })
            Button('首选项put')
              .ButtonStyle()
              .onClick(() => {
                if (preferences) {
                  preferences.has("name", (err, val) => {
                    if (err) {
                      console.error(TAG, `Failed to check the key 'startup'. Code:${err.code}, message:${err.message}`);
                      return;
                    }
                    if (val) {
                      console.debug(TAG, "The key 'startup' is contained.");
                    } else {
                      if (preferences) {
                        preferences.put('name', "lufei").then(() => {
                          Logger.debug(TAG, "put key name success")
                        })
                      }
                    }
                  })
                }
              })

            Button('首选项get')
              .ButtonStyle()
              .onClick(() => {
                if (preferences) {
                  preferences.get('name', "lufei").then((value) => {
                    Logger.debug(TAG, "get key name value:" + value)
                  })
                }
              })
            Button('写file')
              .ButtonStyle()
              .onClick(() => {
                let context: Context = getContext(this) as common.UIAbilityContext;
                let applicationContext = context.getApplicationContext()
                let filePath = applicationContext.filesDir + '/test.txt'
                // FileUtils.writeFileSync(filePath, "hello word")
                // FileUtils.writeFileAppendSync(filePath, "123")
                FileUtils.writeFileAppendSync(filePath, "4567", { line: true })
                // FileUtils.writeFile(filePath, "123").then((result) => {
                // }).catch((err: BusinessError) => {
                // })
              })

            Button('读file')
              .ButtonStyle()
              .onClick(() => {
                let context: Context = getContext(this) as common.UIAbilityContext;
                let applicationContext = context.getApplicationContext()
                let filePath = applicationContext.filesDir + '/test.txt'
                let result = FileUtils.readFileSync(filePath)
                console.debug(TAG, "读file:" + result)
              })
            Button('删除file')
              .ButtonStyle()
              .onClick(() => {
                let context: Context = getContext(this) as common.UIAbilityContext;
                let applicationContext = context.getApplicationContext()
                let filePath = applicationContext.filesDir + '/test.txt'
                let result = FileUtils.deleteFileSync(filePath)
                console.debug(TAG, "删除file:" + result)
              })
          }
          .padding({ left: '20vp', right: '20vp' })
          .width(LAYOUT_WIDTH_OR_HEIGHT)
          .height(LAYOUT_WIDTH_OR_HEIGHT)
          .alignItems(HorizontalAlign.Center)
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width(LAYOUT_WIDTH_OR_HEIGHT)
        .height(LAYOUT_WIDTH_OR_HEIGHT)
      }
      .size({ width: LAYOUT_WIDTH_OR_HEIGHT, height: LAYOUT_WIDTH_OR_HEIGHT })
      .title('文件存储')
      .titleMode(NavigationTitleMode.Mini)
    }

    .backgroundColor('#F1F3F5')
    .height(LAYOUT_WIDTH_OR_HEIGHT)
  }
}


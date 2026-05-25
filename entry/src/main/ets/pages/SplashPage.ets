import { TOKEN_KEY } from '../consts/Global'

PersistentStorage.persistProp(TOKEN_KEY, '')

AppStorage.setOrCreate('currentTab', 0)

@Entry
@Component
struct SplashPage {

  @State flag: boolean = false

  onPageShow(): void {
    this.getUIContext().animateTo({
      duration: 1000,
      onFinish: () => {
        setTimeout(() => {
          this.getUIContext().getRouter().replaceUrl({
            url: 'pages/Index'
          }).catch(() => {
            // TODO: Implement error handling.
          })
        }, 200)
      }
    }, () => {
      this.flag = true
    })
  }

  build() {
    Column() {
      if (this.flag) {
        Image($r('app.media.ic_logo')).logoStyle()
          .transition({
            type: TransitionType.Insert,
            opacity: 0,
            translate: {x: -150}
          })
        Text('快速单词记忆神器').titleStyle()
          .transition({
            type: TransitionType.Insert,
            opacity: 0,
            translate: {x: 150}
          })
      }
      Blank()
      Text('© 2026 天神集团 版权所有').footerStyle()
    }.bgStyle()
  }
}

/**
 * 页面背景
 */
@Styles
function bgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_splash_bg'))
  .backgroundImageSize({
    width: '100%',
    height: '100%'
  })
}

/**
 * logo
 */
@Extend(Image)
function logoStyle() {
  .width(90)
  .height(90)
  .margin({ top: 120 })
}

/**
 * 标题
 */
@Extend(Text)
function titleStyle() {
  .fontSize(21)
  .fontWeight(FontWeight.Bold)
  .fontColor(Color.White)
  .margin({ top: 15 })
}

/**
 * 页脚
 */
@Extend(Text)
function footerStyle() {
  .fontSize(12)
  .fontColor('#546B9D')
  .fontWeight(FontWeight.Bold)
  .margin({ bottom: 30 })
}
import { AxiosResponse } from "@ohos/axios";
import { getUserInfo } from "../../api/Api";
import { TOKEN_KEY } from "../../consts/Global";
import { UserInfo } from "../../types/UserInfo";
import { Result } from "../../types/Result";

@Component
export struct MinePage {
  @StorageLink(TOKEN_KEY) @Watch('onTokenChange') token: string = ''
  @State userInfo: UserInfo = {
    nickname: "",
    avatar: ""
  }

  async onTokenChange() {
    if (this.token) {
      let response: AxiosResponse<Result<UserInfo>> = await getUserInfo()
      this.userInfo = response.data.data || { nickname: "", avatar: "" } as UserInfo;
    }
  }

  async aboutToAppear() {
    if (this.token) {
      let response: AxiosResponse<Result<UserInfo>> = await getUserInfo()
      this.userInfo = response.data.data || { nickname: "", avatar: "" } as UserInfo;
    }
  }

  build() {
    Stack() {
      Column() {
        Image(this.token ? this.userInfo.avatar : $r('app.media.img_avatar'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 25 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/LoginPage'
            }, () => {
            })
          })

        Text(this.token ? this.userInfo.nickname : '暂未登录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({ top: 20 })

        if (!this.token) {
          Text('请点击头像登录')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .margin({ top: 4 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundImage(this.token ? this.userInfo.avatar : $r('app.media.img_avatar'))
      .backgroundImageSize({ height: '100%', width: '100%' })
      .backgroundBlurStyle(BlurStyle.Regular)

      Column({ space: 10 }) {
        this.mineItemBuilder($r('app.media.ic_mine_card'), '打卡记录', () => {
          if (this.token) {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/PostHistoryPage' }, () => {
            })
          } else {
            this.getUIContext().getPromptAction().showToast({ message: '请点击头像登录' })
          }
        })

        Divider()

        this.mineItemBuilder($r('app.media.ic_mine_card'), '检查更新', () => {
          this.getUIContext().getPromptAction().showToast({ message: '已是最新' })
        })

        Divider()

        this.mineItemBuilder($r('app.media.ic_mine_card'), '关于', () => {
          this.getUIContext().getPromptAction().showToast({ message: '没有关于' })
        })

        Blank()

        if (this.token) {
          Button('退出登录')
            .width('100%')
            .fontSize(18)
            .backgroundColor(Color.Gray)
            .fontColor(Color.White)
            .onClick(() => this.token = '')
        }
      }
      .width('100%')
      .height('60%')
      .offset({ y: '40%' })
      .borderRadius({ topLeft: 50, topRight: 50 })
      .backgroundColor(Color.White)
      .padding(30)

    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }

  @Builder
  mineItemBuilder(icon: Resource, title: string, callback?: () => void) {
    Row({ space: 10 }) {
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }.width('100%')
    .height(40)
    .onClick(() => {
      callback && callback();
    })
  }
}


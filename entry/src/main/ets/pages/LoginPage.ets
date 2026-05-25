import { AxiosResponse } from '@ohos/axios';
import { sendCode, login, checkIn } from "../api/Api";
import { TOKEN_KEY } from '../consts/Global';
import { Result } from '../types/Result';

@Entry
@Component
struct LoginPage {

  @StorageLink(TOKEN_KEY) token: string = '';

  @State phone: string = '';
  @State code: string = '';
  @State btnDisabled: boolean = false;
  @State btnText: string = '获取验证码';

  @StorageLink('currentTab') currentTab: number = 0

  build() {
    Column() {
      // 返回按钮
      Image($r('app.media.ic_back'))
        .backStyle()
        .alignSelf(ItemAlign.Start)
        .onClick(() => {
          this.getUIContext().getRouter().back()
        })

      Blank()


      Column() {
        Text('欢迎登录').titleStyle()

        // 手机号输入框
        Row() {
          Image($r('app.media.ic_phone'))
            .iconStyle()
          TextInput({ placeholder: '请输入手机号', text: this.phone })
            .inputStyle()
            .onChange((value: string) => {
              this.phone = value;
            })
        }.margin({ top: 30 })

        Divider().color(Color.Blue)

        // 验证码输入框
        Row() {
          Image($r('app.media.ic_code'))
            .iconStyle()
          TextInput({ placeholder: '请输入验证码', text: this.code })
            .inputStyle()
            .onChange((value: string) => {
              this.code = value;
            })
          Button(this.btnText)
            .enabled(!this.btnDisabled)
            .buttonStyle1(Color.White, Color.Black)
            .onClick(async () => {
              if (!this.phone) {
                try {
                  this.getUIContext().getPromptAction().showToast({
                    message: '请输入手机号',
                    duration: 3000,
                  });
                } catch (error) {
                  // TODO: Implement error handling.
                }
                return
              }
              this.btnDisabled = true;
              let time = 60;
              let timer = setInterval(() => {
                time--;
                this.btnText = '重新获取 (' + time + ')s';
                if (time <= 0) {
                  clearInterval(timer);
                  this.btnDisabled = false;
                  this.btnText = '获取验证码';
                }
              }, 1000);
              let res: AxiosResponse = await sendCode(this.phone)
              this.code = res.data.data;
            })
        }.margin({ top: 20 })

        Divider()
          .color(Color.Blue)
          .margin({ right: 120 })

        Button('立即登录')
          .buttonStyle1(Color.Black, Color.White)
          .width('100%')
          .margin({ top: 50 })
          .onClick(async () => {
            try {
              if (!this.phone) {
                this.getUIContext().getPromptAction().showToast({ message: '请输入手机号' })
                return
              }
              if (!this.code) {
                this.getUIContext().getPromptAction().showToast({ message: '请输入验证码' })
                return
              }
              let res: AxiosResponse<Result<string>> = await login({
                phone: this.phone,
                code: this.code,
              })

              this.token = res.data.data ?? ''

              if (this.currentTab === 0) {
                // 立即打卡，然后跳转到圈子
                // 通过路由获取参数
                let params = this.getUIContext().getRouter().getParams() as Record<string, number>

                await checkIn({
                  rightCount: params?.rightCount,
                  answeredCount: params?.answeredCount,
                  timeUsed: params?.timeUsed
                })
                this.getUIContext().getPromptAction().showToast({ message: '打卡成功' })
                this.currentTab = 1
              }
              this.getUIContext().getRouter().back()
            } catch (error) {
              console.log(error)
              this.getUIContext().getPromptAction().showToast({ message: error ?? '登录失败' })
            }
          })

        Row() {
          Text('登录表示示你已同意').fontSize(10)
            .fontColor('#546B9D')
          Text('《用户协议》')
            .fontSize(10)
            .fontColor('#00B3FF')

          Text('和').fontSize(10)
            .fontColor('#546B9D')

          Text('《用户协议》')
            .fontSize(10)
            .fontColor('#00B3FF')

        }.margin({ top: 20 })
      }.formBgStyle()

      Row({ space: 10 }) {
        Image($r('app.media.ic_logo'))
          .width(36)
          .height(36)
        Text('快速记单词神器')
          .fontSize(20)
          .fontColor('#546B9D')
          .fontWeight(FontWeight.Bold)
      }.margin({ top: 70 })

      Text('Copyright © 2026 天神集团 All rights reserved.')
        .fontSize(12)
        .fontColor('#546B9D')
        .fontWeight(FontWeight.Bold)
        .margin(10)

    }.loginBgStyle()
  }
}

@Styles
function loginBgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_login_bg'))
  .backgroundImageSize({
    width: '100%',
    height: '100%',
  })
  .padding({
    top: 30,
    bottom: 30,
    left: 20,
    right: 20,
  })
}

@Styles
function backStyle() {
  .width(25)
  .height(25)
}

@Styles
function formBgStyle() {
  .backgroundColor(Color.White)
  .padding(30)
  .borderRadius(20)
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Bold)
  .fontSize(22)
}

@Styles
function iconStyle() {
  .width(24)
  .height(24)
}

@Extend(TextInput)
function inputStyle() {
  .height(40)
  .layoutWeight(1)
  .fontSize(14)
  .backgroundColor(Color.Transparent)
}

@Extend(Button)
function buttonStyle1(bgColor: ResourceColor, fontColor: ResourceColor) {
  .type(ButtonType.Normal)
  .fontSize(14)
  .fontWeight(FontWeight.Medium)
  .borderWidth(1)
  .borderRadius(5)
  .backgroundColor(bgColor)
  .fontColor(fontColor)
}
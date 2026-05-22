import axios, { AxiosResponse } from '@ohos/axios'
import { LoginParams } from '../types/Login';

@Entry
@Component
struct LoginPage {

  @State phone: string = '';
  @State code: string = '';
  @State btnDisabled: boolean = false;
  @State btnText: string = '获取验证码';
  build() {
    Column({space: 40}) {
      TextInput({placeholder: '请输入手机号', text: this.phone})
        .type(InputType.PhoneNumber)
        .onChange((value: string) => {
          this.phone = value;
        })
      Row({space: 10}) {
        TextInput({placeholder: '请输入验证码', text: this.code})
          .layoutWeight(1)
          .type(InputType.Number)
          .onChange((value: string) => {
            this.code = value;
          })
        Button(this.btnText)
          .enabled(!this.btnDisabled)
          .onClick(() => {
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
            if (this.phone.length !== 11) {
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
            axios.get('http://localhost:3000/word/user/code', {
              params: {
                phone: this.phone,
              },
            })
              .then((res: AxiosResponse) => {
                console.log('响应数据:', JSON.stringify(res.data));
                if (res.data.code === 200) {
                  this.code = res.data.data.code;
                } else {
                  this.getUIContext().getPromptAction().openToast({
                    message: res.data.message,
                    duration: 3000,
                  });
                }
              }).catch(() => {
            })
          })
      }
      Button('登录').width('100%')
        .onClick(() => {
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
          if (!this.code) {
            try {
              this.getUIContext().getPromptAction().showToast({
                message: '请输入验证码',
                duration: 3000,
              });
            } catch (error) {
              // TODO: Implement error handling.
            }
            return
          }
          axios.post<LoginParams, AxiosResponse>('http://localhost:3000/word/user/login', {
            phone: this.phone,
            code: this.code,
          }).then((res: AxiosResponse) => {
            console.log('响应数据:', JSON.stringify(res.data));
            if (res.data.code === 200) {
              this.getUIContext().getPromptAction().openToast({
                message: '登录成功',
                duration: 3000,
              });
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Index',
              });
            } else {
              this.getUIContext().getPromptAction().openToast({
                message: res.data.message,
                duration: 3000,
              });
            }
          })
        })
    }.alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('90%')
    .height('100%')
    .margin(20)
  }
}
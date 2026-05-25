import { checkIn } from "../../api/Api"
import { TOKEN_KEY } from "../../consts/Global"
import { convertMillisecondsToTime } from "../../utils/DateUtil"
import { ControlButtonStyleModifier } from "../styles/CommonStyles"
import { StatItem } from "./StatItem"
import { emitter } from "@kit.BasicServicesKit"

@CustomDialog
export struct ResultDialog {
  answeredCount: number = 0
  rightCount: number = 0
  timeUsed: number = 0
  customDialogController: CustomDialogController
  @StorageLink('currentTab') currentTab: number = 0
  @StorageProp(TOKEN_KEY) token: string = ''
  resetPractice: () => void = () => {
  }
  startPractice: () => void = () => {
  }

  build() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_close'))
        .width(25)
        .height(25)
        .alignSelf(ItemAlign.End)
        .onClick(() => {
          this.resetPractice()
          this.customDialogController.close()
        })

      Column({ space: 10 }) {
        Image($r('app.media.img_post'))
          .width('100%')
          .borderRadius(10)
        // 用时
        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '用时',
          fontColor: Color.Black
        }) {
          Text(convertMillisecondsToTime(this.timeUsed))
        }

        // 准确率
        StatItem({
          icon: $r('app.media.ic_accuracy'),
          name: '准确率',
          fontColor: Color.Black
        }) {
          Text((this.answeredCount > 0 ? (this.rightCount / this.answeredCount * 100).toFixed() : 0) + '%')
        }

        // 个数
        StatItem({
          icon: $r('app.media.ic_count'),
          name: '个数',
          fontColor: Color.Black
        }) {
          Text((this.answeredCount > 0 ? this.answeredCount : 0).toString())
        }

        Divider()

        Row({ space: 60 }) {
          Button('再来一局').attributeModifier(new ControlButtonStyleModifier({
            bg: Color.White,
            font: Color.Black,
            border: Color.Black
          }))
            .onClick(() => {
              this.resetPractice()
              this.customDialogController.close()
              this.startPractice()
            })
          Button(this.token ? '立即打卡' : '登录打卡').attributeModifier(new ControlButtonStyleModifier({
            bg: Color.Black,
            font: Color.White,
            border: Color.Black
          }))
            .onClick(async () => {
              this.resetPractice()
              this.customDialogController.close()

              if (this.token) {
                // 立即打卡，然后跳转到圈子
                await checkIn({
                  rightCount: this.rightCount,
                  answeredCount: this.answeredCount,
                  timeUsed: this.timeUsed
                })
                this.getUIContext().getPromptAction().showToast({ message: '打卡成功' })
                emitter.emit({ eventId: 1 })
                this.currentTab = 1
              } else {
                this.getUIContext().getRouter().pushUrl({
                  url: 'pages/LoginPage',
                  params: {
                    rightCount: this.rightCount,
                    answeredCount: this.answeredCount,
                    timeUsed: this.timeUsed
                  }
                }, () => {
                })
              }
            })
        }

      }
      .backgroundColor(Color.White)
      .width('100%')
      .padding(10)
      .borderRadius(10)
    }
    .backgroundColor(Color.Transparent)
    .width('80%')
  }
}
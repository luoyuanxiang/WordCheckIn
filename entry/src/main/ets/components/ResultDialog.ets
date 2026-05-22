import { convertMillisecondsToTime } from "../utils/DateUtil"
import { StatItem } from "./StatItem"

@CustomDialog
export struct ResultDialog {
  answeredCount: number = 0
  rightCount: number = 0
  timeUsed: number = 0
  customDialogController: CustomDialogController
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
          Button('再来一局').controlButtonStyle({
            bg: Color.White,
            font: Color.Black,
            border: Color.Black
          })
            .onClick(() => {
              this.resetPractice()
              this.customDialogController.close()
              this.startPractice()
            })
          Button('登录打卡').controlButtonStyle({
            bg: Color.Black,
            font: Color.White,
            border: Color.Black
          })
            .onClick(() => {
              this.resetPractice()
              this.customDialogController.close()
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

interface GeneratedTypeLiteralInterface_2 {
  bg: ResourceColor; // 背景色
  font: ResourceColor; // 字体颜色
  border: ResourceColor;
}

/**
 * 控制按钮
 */
@Extend(Button)
function controlButtonStyle(color: GeneratedTypeLiteralInterface_2) {
  .fontSize(16)
  .borderWidth(1)
  .backgroundColor(color.bg)
  .borderColor(color.border)
  .fontColor(color.font)
}
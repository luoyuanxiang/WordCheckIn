import { AnswerStatus } from "../enums/AnswerStatus";
import { OptionStatus } from "../enums/OptionStatus";

@Component
export struct OptionButton {
  option: string = ''
  answer: string = ''
  @State optionStatus: OptionStatus = OptionStatus.Default

  @Prop selectedOption: string

  @Prop @Watch('onAnswerStatusChange') answerStatus: AnswerStatus

  onAnswerStatusChange() {
    if (this.option === this.answer) {
      this.optionStatus = OptionStatus.Right
    } else {
      if (this.option === this.selectedOption) {
        this.optionStatus = OptionStatus.Wrong
      } else {
        this.optionStatus = OptionStatus.Default
      }
    }
  }

  getColor() {
    switch (this.optionStatus) {
      // 默认
      case OptionStatus.Default:
        return ({
          bg: Color.White,
          font: Color.Black
        } as GeneratedTypeLiteralInterface_1)
      // 正确
      case OptionStatus.Right:
        return ({
          bg: '#1DBF7B',
          font: Color.White
        } as GeneratedTypeLiteralInterface_1)
      // 错误
      case OptionStatus.Wrong:
        return ({
          bg: '#FA635F',
          font: Color.White
        } as GeneratedTypeLiteralInterface_1)
    }
  }

  build() {
    Stack() {
      Button(this.option).optionButtonStyle(this.getColor())
      if (this.optionStatus === OptionStatus.Right) {
        Image($r('app.media.ic_right'))
          .width(22)
          .height(22)
          .offset({ x: 10 })
      } else {
        Image($r('app.media.ic_wrong'))
          .width(22)
          .height(22)
          .offset({ x: 10 })
      }

    }.alignContent(Alignment.Start)
  }
}

/**
 * 选项按钮
 */
interface GeneratedTypeLiteralInterface_1 {
  bg: ResourceColor; // 背景色
  font: ResourceColor; // 字体颜色
}

/**
 * 选项按钮
 */
@Extend(Button)
function optionButtonStyle(color: GeneratedTypeLiteralInterface_1) {
  .width(240)
  .height(48)
  .fontSize(16)
  .type(ButtonType.Normal)
  .fontWeight(FontWeight.Medium)
  .borderRadius(8)
  .backgroundColor(color.bg)
  .fontColor(color.font)
}
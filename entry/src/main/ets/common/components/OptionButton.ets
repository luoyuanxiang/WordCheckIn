import { AnswerStatus } from "../../enums/AnswerStatusEnum";
import { OptionStatus } from "../../enums/OptionStatusEnum";
import { OptionButtonStyleI } from "../../types/OptionButtonStyle";
import{ OptionButtonStyleModifier } from "../../common/styles/CommonStyles";

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
        } as OptionButtonStyleI)
      // 正确
      case OptionStatus.Right:
        return ({
          bg: '#1DBF7B',
          font: Color.White
        } as OptionButtonStyleI)
      // 错误
      case OptionStatus.Wrong:
        return ({
          bg: '#FA635F',
          font: Color.White
        } as OptionButtonStyleI)
    }
  }

  build() {
    Stack() {
      Button(this.option)
        .attributeModifier(new OptionButtonStyleModifier(this.getColor()))
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
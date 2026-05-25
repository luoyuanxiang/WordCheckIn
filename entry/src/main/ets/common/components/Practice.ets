import { OptionButton } from './OptionButton';
import { ResultDialog } from './ResultDialog';
import { StatItem } from './StatItem';
import {
  ControlButtonStyleModifier,
  PracticeBgStyleModifier,
  SentenceStyleModifier,
  StatBgStyleModifier,
  WordStyleModifier
} from '../styles/CommonStyles';
import { AnswerStatus } from '../../enums/AnswerStatusEnum';
import { PracticeStatus } from '../../enums/PracticeStatusEnum';
import { getRandomQuestion, Question } from '../../model/Question';

/**
 * 答题页面
 */
@Component
export struct PracticePage {
  // 状态
  @State practiceStatus: PracticeStatus = PracticeStatus.Stopped;
  @State currentIndex: number = 0;
  @State answerStatus: AnswerStatus = AnswerStatus.Answering;
  @State selectedOption: string = ''
  @State answeredCount: number = 0
  @State rightCount: number = 0 // 正确个数
  @State totalCount: number = 20
  @State questions: Question[] = getRandomQuestion(this.totalCount);

  timerController: TextTimerController = new TextTimerController();
  timeUsed: number = 0
  customDialogController: CustomDialogController = new CustomDialogController({
    builder: ResultDialog({
      answeredCount: this.answeredCount,
      rightCount: this.rightCount,
      timeUsed: this.timeUsed,
      resetPractice: () => {
        this.questions = getRandomQuestion(this.totalCount);
        this.currentIndex = 0
        this.answeredCount = 0
        this.rightCount = 0
        this.timeUsed = 0
        this.timerController.reset()
        this.answerStatus = AnswerStatus.Answering
        this.selectedOption = ''
        this.practiceStatus = PracticeStatus.Stopped
      },
      startPractice: () => {
        this.startPractice()
      },
    }),
    customStyle: true,
    autoCancel: false
  })

  // 开始答题
  startPractice() {
    this.practiceStatus = PracticeStatus.Running;
    this.timerController.start()
  }

  pausePractice() {
    this.practiceStatus = PracticeStatus.Paused;
    this.timerController.pause()
  }

  stopPractice() {
    this.practiceStatus = PracticeStatus.Stopped;
    this.timerController.pause()
    this.customDialogController.open()
  }

  build() {
    Column({ space: 10 }) {

      // 顶部
      Column({ space: 10 }) {
        // 准确率
        StatItem({
          icon: $r('app.media.ic_accuracy'),
          name: '准确率',
          fontColor: Color.Black
        }) {
          Text((this.answeredCount > 0 ? (this.rightCount / this.answeredCount * 100).toFixed() : 0) + '%')
            .width(100)
            .textAlign(TextAlign.Center)
        }

        // 进度
        StatItem({
          icon: $r('app.media.ic_progress'),
          name: '进度',
          fontColor: Color.Black
        }) {
          Progress({ value: this.answeredCount, total: this.totalCount }).width(100)
        }

        // 个数
        StatItem({
          icon: $r('app.media.ic_count'),
          name: '个数',
          fontColor: Color.Black
        }) {
          Button(this.totalCount.toString())
            .width(100)
            .height(25)
            .backgroundColor('#EBEBEB')
            .fontColor(Color.Black)
            .enabled(this.practiceStatus === PracticeStatus.Stopped)
            .onClick(() => {
              this.getUIContext().showTextPickerDialog({
                range: ['5', '10', '15', '20', '25', '30', '60', '90', '100'],
                value: this.totalCount.toString(),
                onAccept: (value: TextPickerResult) => {
                  this.totalCount = Number(value.value)
                  this.questions = getRandomQuestion(this.totalCount)
                }
              })
            })
        }

        // 用时
        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '用时',
          fontColor: Color.Black
        }) {
          Row() {
            TextTimer({ controller: this.timerController })
              .onTimer((_utc: number, elapsedTime: number) => {
                this.timeUsed = elapsedTime
              })
          }.width(100)
          .justifyContent(FlexAlign.Center)
        }

      }.attributeModifier(new StatBgStyleModifier())

      // 题目
      Column({ space: 10 }) {
        Text(this.questions[this.currentIndex].word).attributeModifier(new WordStyleModifier())
        Text(this.questions[this.currentIndex].sentence).attributeModifier(new SentenceStyleModifier())
      }

      // 选项
      Column({ space: 10 }) {
        ForEach(this.questions[this.currentIndex].options, (item: string) => {
          OptionButton({
            option: item,
            selectedOption: this.selectedOption,
            answer: this.questions[this.currentIndex].answer,
            answerStatus: this.answerStatus
          }).enabled(this.answerStatus === AnswerStatus.Answering)
            .onClick(() => {
              // 判断练习状态
              if (this.practiceStatus !== PracticeStatus.Running) {
                this.getUIContext().getPromptAction().openToast({ message: '请先点击开始测试' }).catch(() => {
                  // Implement error handling.
                })
                return
              }
              // 判断正误
              this.selectedOption = item

              // 更新统计信息
              this.answeredCount++
              if (item === this.questions[this.currentIndex].answer) {
                this.rightCount++
              }
              // 切换题目
              this.answerStatus = AnswerStatus.Answered
              if (this.currentIndex < this.questions.length - 1) {
                setTimeout(() => {
                  this.currentIndex++
                  this.answerStatus = AnswerStatus.Answering
                }, 500)
              } else {
                this.stopPractice()
              }
            })
        }, (item: string, index: number) => this.questions[this.currentIndex].word + '_' + item + index)
      }

      // 底部
      Row({ space: 60 }) {
        Button('停止测试')
          .attributeModifier(new ControlButtonStyleModifier({
            bg: Color.Transparent,
            border: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
            font: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
          }))
          .onClick(() => this.stopPractice())
          .enabled(this.practiceStatus !== PracticeStatus.Stopped)

        Button(this.practiceStatus === PracticeStatus.Running ? '暂停测试' : '开始测试')
          .attributeModifier(new ControlButtonStyleModifier({
            bg: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.Black,
            border: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.Black,
            font: Color.White,
          }))
          .onClick(() => {
            this.practiceStatus === PracticeStatus.Running ? this.pausePractice() : this.startPractice()
          })
          .stateEffect(false)
      }
    }
    .attributeModifier(new PracticeBgStyleModifier())
  }
}

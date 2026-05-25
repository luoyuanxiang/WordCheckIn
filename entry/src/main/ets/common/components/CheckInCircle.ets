import { AxiosResponse } from "@ohos/axios"
import { createLike, deleteLike, getCheckInInfoList } from "../../api/Api"
import { TOKEN_KEY } from "../../consts/Global"
import { PostInfo, PostInfoDto } from "../../types/CheckIn"
import { ResultPage, Result } from "../../types/Result"
import { convertMillisecondsToTime } from "../../utils/DateUtil"
import { StatItem } from "./StatItem"
import { emitter } from "@kit.BasicServicesKit"

@Component
export struct CheckInCircle {
  @State postInfoList: PostInfo[] = []
  @State page: number = 1
  @State total: number = 0
  @StorageProp(TOKEN_KEY) @Watch('onTokenChange') token: string = ''
  scroller: Scroller = new Scroller()
  @State isLoading: boolean = false

  onTokenChange() {
    this.getPostInfoPage()
  }

  async getPostInfoPage() {
    if (this.token) {
      const res: AxiosResponse<Result<ResultPage<PostInfo>>> = await getCheckInInfoList(this.page)
      res.data.data?.records.forEach(item => this.postInfoList.push(item))
      this.total = res.data.data?.total || 0
      this.page++
    } else {
      this.page = 1
      this.postInfoList = []
      this.total = 0
    }
  }

  refresh() {
    this.isLoading = true
    this.page = 1
    this.postInfoList = []
    this.total = 0
    this.getPostInfoPage()
    this.isLoading = false
  }

  aboutToAppear(): void {
    this.getPostInfoPage()
    emitter.on({ eventId: 1 }, () => {
      this.refresh()
    })
  }

  build() {
    Column() {
      Text('英语打卡圈')
        .fontSize(18)
        .margin({ top: 45 })
        .fontWeight(FontWeight.Bold)

      Divider()
        .color(Color.Black)
        .margin({
          left: 20,
          right: 20,
          top: 10,
        })

      if (this.token) {
        // 打卡列表
        if (this.isLoading) {
          this.loadingBuilder()
        } else {
          this.listBuilder()
        }
      } else {
        this.unLoginBuilder()
      }

    }.height('100%')
    .width('100%')
  }

  @Builder
  loadingBuilder() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_loading'))
        .width(30)
        .height(30)

      Text('加载中...')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#7e8892')
    }.width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  unLoginBuilder() {
    Column({ space: 30 }) {
      Image($r('app.media.ic_unLogin_bg'))
        .width(177)
        .height(177)

      Text('未登录暂无数据')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#999999')

      Button('去登录')
        .fontColor(Color.White)
        .fontSize(14)
        .width(100)
        .height(34)
        .backgroundColor('#43C6A0')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/LoginPage'
          }, () => {
          })
        })
    }.width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  listBuilder() {
    Stack() {
      List({ scroller: this.scroller }) {
        ForEach(this.postInfoList, (post: PostInfo) => {
          ListItem() {
            PostItem({ post: post })
          }
        })
      }.width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      .onReachEnd(() => {
        if (this.total != 0 && (this.postInfoList.length < this.total)) {
          this.getPostInfoPage()
        } else {
          this.getUIContext().getPromptAction().showToast({ message: '没有更多数据了' })
        }
      })

      Column({ space: 20 }) {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_top'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.scroller.scrollToIndex(0)
        })

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_refresh'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.refresh()
        })
      }
      .offset({ x: -20, y: -50 })
    }.width('100%')
    .layoutWeight(1)
    .alignContent(Alignment.BottomEnd)
  }
}

@Component
struct PostItem {
  @ObjectLink post: PostInfo

  build() {
    Column({ space: 10 }) {
      // 头部
      Row({ space: 10 }) {
        Image(this.post.avatarUrl)
          .width(40)
          .height(40)
          .borderRadius(20)

        Text(this.post.nickname).height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)

        Blank()

        Text(this.post.createTime)
          .height(40)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor('#999999')

      }.width('100%')

      // 描述
      Text(this.post.postText)
        .width('100%')

      // 统计部分
      Row() {
        Column() {
          StatItem({
            icon: $r('app.media.ic_timer_white'),
            name: '用时',
            fontColor: Color.White
          }) {
            Text(convertMillisecondsToTime(this.post.timeUsed))
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_accuracy_white'),
            name: '准确率',
            fontColor: Color.White
          }) {
            Text(this.post.answeredCount === 0 ? '0%' :
              (this.post.rightCount / this.post.answeredCount * 100).toFixed(0) + '%')
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_count_white'),
            name: '个数',
            fontColor: Color.White
          }) {
            Text(this.post.answeredCount.toString())
              .statTextStyle()
          }

        }
        .padding(10)
        .borderRadius(10)
        .layoutWeight(1)
        .backgroundImage($r('app.media.img_post_bg'))
        .backgroundImageSize(ImageSize.Cover)

        // 点赞
        Column() {
          Text(this.post.likeCount.toString())
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.post.isLike ? '#3ECBA1' : '#000000')

          Image(this.post.isLike ? $r('app.media.ic_post_like_selected') : $r('app.media.ic_post_like'))
            .width(26)
            .height(26)
            .onClick(async () => {
              try {
                if (this.post.isLike) {
                  this.post.likeCount--
                  this.post.isLike = false
                  await deleteLike(this.post.id.toString())
                  this.getUIContext().getPromptAction().showToast({ message: '取消点赞成功' })
                } else {
                  this.post.isLike = true
                  this.post.likeCount++
                  await createLike(this.post.id.toString())
                  this.getUIContext().getPromptAction().showToast({ message: '点赞成功' })
                }
              } catch (e) {
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: e ?? '未知错误', alignment: Alignment.Center })
              }

            })
        }.width(50)

      }.width('100%')
      .alignItems(VerticalAlign.Bottom)

    }
    .padding(10)
    .width('90%')
    .margin({ top: 10 })
    .borderRadius(10)
    .shadow({ radius: 20 })
  }
}

@Extend(Text)
function statTextStyle() {
  .width(100)
  .textAlign(TextAlign.End)
  .fontWeight(FontWeight.Medium)
  .fontColor(Color.White)
}






@Entry
@Component
struct Index {
  @State isLightOn: boolean = false

  build() {
    Column() {
      Text(this.isLightOn ? '灯已开启' : '灯已关闭')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 80, bottom: 40 })
        .fontColor(this.isLightOn ? '#FFB800' : '#666666')

      // 灯泡图标区域
      Stack() {
        // 光晕效果（开灯时显示）
        if (this.isLightOn) {
          Circle()
            .width(200)
            .height(200)
            .fill('#FFEB3B33')
            .blur(40)

          Circle()
            .width(150)
            .height(150)
            .fill('#FFEB3B55')
            .blur(20)
        }

        // 灯泡主体
        Column() {
          // 灯泡圆形部分
          Circle()
            .width(100)
            .height(100)
            .fill(this.isLightOn ? '#FFEB3B' : '#424242')
            .animation({
              duration: 300,
              curve: Curve.EaseInOut
            })

          // 灯座
          Column()
            .width(50)
            .height(30)
            .backgroundColor(this.isLightOn ? '#9E9E9E' : '#616161')
            .borderRadius({ topLeft: 5, topRight: 5 })
            .animation({
              duration: 300,
              curve: Curve.EaseInOut
            })

          // 灯座螺纹
          Column() {
            ForEach([1, 2, 3], (item: number) => {
              Row()
                .width(45 - item * 2)
                .height(4)
                .borderRadius(2)
                .backgroundColor(this.isLightOn ? '#757575' : '#424242')
                .margin({ bottom: 2 })
            })
          }
          .alignItems(HorizontalAlign.Center)
        }
        .onClick(() => {
          this.isLightOn = !this.isLightOn
        })
      }
      .width(200)
      .height(220)
      .margin({ bottom: 60 })

      // 开关按钮
      Button(this.isLightOn ? '关灯' : '开灯')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .width(160)
        .height(48)
        .borderRadius(24)
        .backgroundColor(this.isLightOn ? '#FF9800' : '#2196F3')
        .fontColor(Color.White)
        .onClick(() => {
          this.isLightOn = !this.isLightOn
        })

      // 提示文字
      Text('点击灯泡或按钮切换开关')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isLightOn ? '#FFFDE7' : '#ECEFF1')
    .justifyContent(FlexAlign.Center)
    .animation({
      duration: 300,
      curve: Curve.EaseInOut
    })
  }
}

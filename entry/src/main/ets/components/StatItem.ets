@Component
export struct StatItem {
  icon: ResourceStr = '' // 图标
  name: string = '' // 名称
  @BuilderParam statComp: () => void // 自定义组件
  fontColor: Color = Color.White
  build() {
    Row({space: 10}) {
      Image(this.icon)
        .height(14)
        .width(14)
      Text(this.name)
        .fontColor(this.fontColor)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
      Blank()
      this.statComp()
    }
    .width('90%')
    .height(30)
  }
}
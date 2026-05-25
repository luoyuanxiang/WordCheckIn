import { TabIconStyleModifier, TabTitleStyleModifier } from '../common/styles/CommonStyles'
import { PracticePage } from '../common/components/Practice'
import { CheckInCircle } from '../common/components/CheckInCircle'
import { MinePage } from '../common/components/MinePage'

@Entry
@Component
struct Index {

  @StorageLink('currentTab') currentTab: number = 2

  build() {
    Tabs({ index: this.currentTab }) {
      TabContent() {
        PracticePage()
      }
      .tabBar(this.customTabBar($r('app.media.ic_practice'), $r('app.media.ic_practice_selected'), '答题', 0))

      TabContent() {
        CheckInCircle()
      }
      .tabBar(this.customTabBar($r('app.media.ic_circle'), $r('app.media.ic_circle_selected'), '圈子', 1))

      TabContent() {
        MinePage()
      }.tabBar(this.customTabBar($r('app.media.ic_mine'), $r('app.media.ic_mine_selected'), '我的', 2))

    }.barPosition(BarPosition.End)
    .onChange(index => {
      this.currentTab = index
      console.log('currentTab: ', index, this.currentTab === 1)
    })
  }

  @Builder
  customTabBar(
    icon: ResourceStr,
    selectedIcon: ResourceStr,
    title: string,
    index: number) {
    Column() {
      Image(index === this.currentTab ? selectedIcon : icon).attributeModifier(new TabIconStyleModifier())
      Text(title).attributeModifier(new TabTitleStyleModifier(index === this.currentTab ? Color.Black : '#959595'))
    }
  }
}

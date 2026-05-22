import { OptionButtonStyleI } from '../../types/OptionButtonStyle';
import { ControlButtonStyleI } from '../../types/ControlButtonStyle';

/**
 * 选项按钮样式
 */
export class OptionButtonStyleModifier implements AttributeModifier<ButtonAttribute> {
  public color: OptionButtonStyleI;

  constructor(color: OptionButtonStyleI) {
    this.color = color;
  }

  applyNormalAttribute(attribute: ButtonAttribute) {
    attribute.width(240)
      .height(48)
      .fontSize(16)
      .type(ButtonType.Normal)
      .fontWeight(FontWeight.Medium)
      .borderRadius(8)
      .backgroundColor(this.color.bg)
      .fontColor(this.color.font)
  }
}

/**
 * 控制按钮样式
 */
export class ControlButtonStyleModifier implements AttributeModifier<ButtonAttribute> {
  public color: ControlButtonStyleI;

  constructor(color: ControlButtonStyleI) {
    this.color = color;
  }

  applyNormalAttribute(attribute: ButtonAttribute) {
    attribute.fontSize(16)
      .borderWidth(1)
      .backgroundColor(this.color.bg)
      .borderColor(this.color.border)
      .fontColor(this.color.font)
  }
}

/**
 * 练习背景样式
 */
export class PracticeBgStyleModifier implements AttributeModifier<ColumnAttribute> {
  applyNormalAttribute(attribute: ColumnAttribute): void {
    attribute.width('100%')
      .height('100%')
      .backgroundImage($r('app.media.img_practice_bg'))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .justifyContent(FlexAlign.SpaceEvenly)
  }
}

/**
 * 统计背景样式
 */
export class StatBgStyleModifier implements AttributeModifier<ColumnAttribute> {
  applyNormalAttribute(attribute: ColumnAttribute): void {
    attribute.width('90%')
      .borderRadius(10)
      .backgroundColor(Color.White)
  }
}

/**
 * 单词样式
 */
export class WordStyleModifier implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(attribute: TextAttribute) {
    attribute.fontSize(50)
      .fontWeight(FontWeight.Bold)
  }
}

/**
 * 句子样式
 */
export class SentenceStyleModifier implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(attribute: TextAttribute) {
    attribute.height(40)
      .fontSize(16)
      .fontColor('#9ba1a5')
      .fontWeight(FontWeight.Medium)
      .width('80%')
      .textAlign(TextAlign.Center)
  }
}

/**
 * tabs 图标样式
 */
export class TabIconStyleModifier implements AttributeModifier<ImageAttribute> {
  applyNormalAttribute(attribute: ImageAttribute) {
    attribute.width(25)
      .height(25)
  }
}

/**
 * tabs 标题样式
 */
export class TabTitleStyleModifier implements AttributeModifier<TextAttribute> {
  constructor(color: ResourceColor) {
    this.color = color;
  }

  public color: ResourceColor;

  applyNormalAttribute(attribute: TextAttribute) {
    attribute.fontSize(10)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.color)
      .margin({ bottom: 2 })
  }
}
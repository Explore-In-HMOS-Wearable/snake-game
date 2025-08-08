import { Direction } from '../lib/Types';

@Component
export struct DirectionButton {
  @Prop @Require btnDirection: Direction;
  @Prop @Require icon: Resource;

  build() {
    Row() {
      Image(this.icon)
        .opacity($r('app.float.direction_opacity'))
        .width($r('app.float.direction_size'))
        .height($r('app.float.direction_size'))
        .scale({ x: 2, y: 2 })
        .margin({ right: this.btnDirection === 'left' || this.btnDirection === 'right' ? 4 : 0 })
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}


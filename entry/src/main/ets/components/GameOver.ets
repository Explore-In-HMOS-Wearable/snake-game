@Component
export struct GameOver {
  @Prop @Require score: number;
  onRestart: () => void = () => {
  }

  build() {
    Column({space: $r('app.float.gameover_gap')}) {
      Text($r('app.string.gameOver'))
        .fontSize($r('app.float.gameover_title'))
        .fontColor('#FF0000')
        .fontWeight(FontWeight.Bold)

      Text($r('app.string.score', this.score.toString()))
        .fontSize($r('app.float.gameover_score'))
        .fontColor('#fff')

      Text($r('app.string.tapToRestart'))
        .fontSize($r('app.float.gameover_restart_text'))
        .fontColor('#888888')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .position({
      left: 0,
      right: 0,
      top: 0,
      bottom: 0
    })
    .backgroundColor('rgba(0, 10, 10, 0.8)')
    .onClick(() => this.onRestart())
  }
}

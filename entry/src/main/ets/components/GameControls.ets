import { DirectionButton } from './DirectionButton';
import { Direction } from '../lib/Types';
import { GAME_CONFIG } from '../lib/Constants';

@Component
export struct GameControls {
  onDirectionPress: (direction: Direction) => void = () => {
  }

  build() {
    RelativeContainer() {
      DirectionButton({
        btnDirection: 'up',
        icon: $r('app.media.chevronup'),
      })
        .position({ top: 0 })
        .height(GAME_CONFIG.CANVAS_OFFSET)
        .width('100%')
        .onClick(() => this.onDirectionPress('up'))

      DirectionButton({
        btnDirection: 'left',
        icon: $r('app.media.chevronleft'),
      })
        .position({ left: 0, top: 0 })
        .width(GAME_CONFIG.CANVAS_OFFSET)
        .height(GAME_CONFIG.MaxVP)
        .onClick(() => this.onDirectionPress('left'))

      DirectionButton({
        btnDirection: 'right',
        icon: $r('app.media.chevronright'),
      }).position({ left: GAME_CONFIG.MaxVP - GAME_CONFIG.CANVAS_OFFSET })
        .width(GAME_CONFIG.CANVAS_OFFSET)
        .height(GAME_CONFIG.MaxVP)
        .onClick(() => this.onDirectionPress('right'))

      DirectionButton({
        btnDirection: 'down',
        icon: $r('app.media.chevrondown'),
      })
        .position({ bottom: 0 })
        .height(GAME_CONFIG.CANVAS_OFFSET)
        .width(GAME_CONFIG.MaxVP)
        .onClick(() => this.onDirectionPress('down'))
    }.height('100%').width('100%')
  }
}


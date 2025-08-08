import { changeDirection, createGame, GameState, moveSnake } from '../lib/Game';
import { GAME_CONFIG } from '../lib/Constants';
import { SnakeRenderer } from '../lib/SnakeRenderer';
import { Direction } from '../lib/Types';
import { GameControls } from '../components/GameControls';
import { GameOver } from '../components/GameOver';

@Entry
@Component
export struct Index {
  @State private game: GameState = createGame(GAME_CONFIG.GRID_SIZE, GAME_CONFIG.GRID_SIZE);
  private gameTimer: number = -1;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private renderer: SnakeRenderer = new SnakeRenderer(this.context);
  private gameSpeed: number = 300;

  aboutToDisappear(): void {
    if (this.gameTimer !== -1) {
      clearTimeout(this.gameTimer);
    }
  }

  private startGame(): void {
    this.gameLoop();
  }

  private restartGame(): void {
    if (this.gameTimer !== -1) {
      clearTimeout(this.gameTimer);
    }
    this.game = createGame(GAME_CONFIG.GRID_SIZE, GAME_CONFIG.GRID_SIZE);
    this.startGame();
  }

  private gameLoop(): void {
    this.renderer.drawGame(this.game);

    if (!this.game.isGameOver) {
      this.gameTimer = setTimeout(() => {
        this.game = moveSnake(this.game);
        this.gameLoop();
      }, this.gameSpeed);
    }
  }

  build() {
    RelativeContainer() {
      GameControls({
        onDirectionPress: (direction: Direction) => {
          this.game = changeDirection(this.game, direction);
        }
      })
      Canvas(this.context)
        .position({ left: GAME_CONFIG.CANVAS_OFFSET, top: GAME_CONFIG.CANVAS_OFFSET })
        .width(GAME_CONFIG.SQUARE_SIZE)
        .height(GAME_CONFIG.SQUARE_SIZE)
        .onReady(() => {
          this.startGame();
        })
        .gesture(
          PanGesture({ fingers: 1, distance: 10 })
            .onActionEnd((event: GestureEvent) => {
              const deltaX = event.offsetX;
              const deltaY = event.offsetY;
              const direction: Direction =
                Math.abs(deltaX) > Math.abs(deltaY) ?
                  deltaX > 0 ? 'right' : 'left' :
                  deltaY > 0 ? 'down' : 'up';

              this.game = changeDirection(this.game, direction);
            })
        )
      if (this.game.isGameOver) {
        GameOver({
          score: this.game.snake.length - 1,
          onRestart: () => this.restartGame()
        })
      }
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 145,
      colors: [['#1f1f1f', 0], ['#0d0d0d', 1]]
    })
  }
}
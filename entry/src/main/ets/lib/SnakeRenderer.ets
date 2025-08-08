import { GAME_CONFIG } from './Constants';
import { GameState } from './Game';
import { Coordinate, Corners } from './Types';

export class SnakeRenderer {
  private img: ImageBitmap = new ImageBitmap('/assets/apricot.svg');
  private context: CanvasRenderingContext2D;

  constructor(context: CanvasRenderingContext2D) {
    this.context = context;
  }

  drawGame(game: GameState): void {
    this.drawBackground();
    this.drawGrid();
    this.drawFood(game.food);
    this.drawSnake(game.snake, game.direction);
  }

  private drawBackground(): void {
    this.context.clearRect(0, 0, GAME_CONFIG.SQUARE_SIZE, GAME_CONFIG.SQUARE_SIZE);
  }

  private drawGrid(): void {
    this.context.strokeStyle = '#2a2a2a';
    this.context.lineWidth = 0.5;

    for (let x = 0; x <= GAME_CONFIG.GRID_SIZE; x++) {
      this.context.beginPath();
      this.context.moveTo(x * GAME_CONFIG.CELL_SIZE, 0);
      this.context.lineTo(x * GAME_CONFIG.CELL_SIZE, GAME_CONFIG.SQUARE_SIZE);
      this.context.stroke();
    }

    for (let y = 0; y <= GAME_CONFIG.GRID_SIZE; y++) {
      this.context.beginPath();
      this.context.moveTo(0, y * GAME_CONFIG.CELL_SIZE);
      this.context.lineTo(GAME_CONFIG.SQUARE_SIZE, y * GAME_CONFIG.CELL_SIZE);
      this.context.stroke();
    }

    this.context.strokeStyle = '#444';
    this.context.lineWidth = 1;
    this.context.strokeRect(0, 0, GAME_CONFIG.SQUARE_SIZE, GAME_CONFIG.SQUARE_SIZE);
  }

  private drawFood(food: Coordinate): void {
    const x = food.x * GAME_CONFIG.CELL_SIZE;
    const y = food.y * GAME_CONFIG.CELL_SIZE;
    this.context.drawImage(this.img, x + 1, y + 1, GAME_CONFIG.CELL_SIZE - 2,
      GAME_CONFIG.CELL_SIZE - 2);
  }

  private drawSnake(segments: Array<Coordinate>, direction: string): void {
    const len = segments.length;

    for (let i = 0; i < len; i++) {
      const segment = segments[i];
      const isHead = i === len - 1;
      const isTail = i === 0;

      const x = segment.x * GAME_CONFIG.CELL_SIZE;
      const y = segment.y * GAME_CONFIG.CELL_SIZE;
      const size = GAME_CONFIG.CELL_SIZE - 2;
      const padding = 1;

      const corners = this.calculateCorners(segments, i, direction, isHead, isTail);
      const gradient = this.createSnakeGradient(x, y, size, isHead);

      this.context.fillStyle = gradient;
      this.drawSelectiveRoundedRect(x + padding, y + padding, size, size, size / 2, corners);
    }
  }

  private calculateCorners(segments: Array<Coordinate>, index: number, direction: string, isHead: boolean,
    isTail: boolean): Corners {
    let roundTopLeft = false
    let roundTopRight = false
    let roundBottomLeft = false
    let roundBottomRight = false

    const segment = segments[index]

    if (isHead) {
      let dx = 0
      let dy = 0

      if (segments.length > 1) {
        const prev = segments[index - 1];
        dx = segment.x - prev.x;
        dy = segment.y - prev.y;
      } else {
        switch (direction) {
          case 'right':
            dx = 1;
            break;
          case 'left':
            dx = -1;
            break;
          case 'down':
            dy = 1;
            break;
          case 'up':
            dy = -1;
            break;
        }
      }

      if (dx === 1) {
        roundTopRight = roundBottomRight = true;
      } else if (dx === -1) {
        roundTopLeft = roundBottomLeft = true;
      } else if (dy === 1) {
        roundBottomLeft = roundBottomRight = true;
      } else if (dy === -1) {
        roundTopLeft = roundTopRight = true;
      }
    }

    if (isTail && segments.length > 1) {
      const next = segments[index + 1];
      const dx = next.x - segment.x;
      const dy = next.y - segment.y;

      if (dx === 1) {
        roundTopLeft = roundBottomLeft = true;
      } else if (dx === -1) {
        roundTopRight = roundBottomRight = true;
      } else if (dy === 1) {
        roundTopLeft = roundTopRight = true;
      } else if (dy === -1) {
        roundBottomLeft = roundBottomRight = true;
      }
    }

    return {
      roundTopLeft,
      roundTopRight,
      roundBottomLeft,
      roundBottomRight
    };
  }

  private createSnakeGradient(x: number, y: number, size: number, isHead: boolean): CanvasGradient {
    const gradient = this.context.createLinearGradient(x, y, x + size, y + size);
    if (isHead) {
      gradient.addColorStop(0, '#66FF66');
      gradient.addColorStop(1, '#339933');
    } else {
      gradient.addColorStop(0, '#33CC33');
      gradient.addColorStop(1, '#226622');
    }
    return gradient;
  }

  private drawSelectiveRoundedRect(x: number, y: number, width: number, height: number, radius: number,
    corners: Corners): void {
    const ctx = this.context;
    ctx.beginPath();
    ctx.moveTo(x + (corners.roundTopLeft ? radius : 0), y);

    if (corners.roundTopRight) {
      ctx.lineTo(x + width - radius, y);
      ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
    } else {
      ctx.lineTo(x + width, y);
    }

    if (corners.roundBottomRight) {
      ctx.lineTo(x + width, y + height - radius);
      ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    } else {
      ctx.lineTo(x + width, y + height);
    }

    if (corners.roundBottomLeft) {
      ctx.lineTo(x + radius, y + height);
      ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
    } else {
      ctx.lineTo(x, y + height);
    }

    if (corners.roundTopLeft) {
      ctx.lineTo(x, y + radius);
      ctx.quadraticCurveTo(x, y, x + radius, y);
    } else {
      ctx.lineTo(x, y);
    }

    ctx.closePath();
    ctx.fill();
  }
}


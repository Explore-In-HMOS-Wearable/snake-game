import { display } from '@kit.ArkUI';

const MAX_VP = display.getPrimaryDisplaySync().width / display.getPrimaryDisplaySync().scaledDensity
const SQUARE_SIZE = MAX_VP / Math.sqrt(2);
const CANVAS_OFFSET = (MAX_VP - SQUARE_SIZE) / 2;
const GRID_SIZE = 11;
const CELL_SIZE = SQUARE_SIZE / GRID_SIZE;

interface cfg {
  CELL_SIZE: number,
  GRID_SIZE: number,
  CANVAS_OFFSET: number,
  SQUARE_SIZE: number,
  MAX_VP: number
}

export const GAME_CONFIG: cfg = {
  CELL_SIZE,
  GRID_SIZE,
  CANVAS_OFFSET,
  SQUARE_SIZE,
  MAX_VP: MAX_VP
}

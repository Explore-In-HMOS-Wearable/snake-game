import { Coordinate, Direction } from './Types';

export interface GameState {
  width: number;
  height: number;
  snake: Coordinate[];
  direction: Direction;
  food: Coordinate;
  isGameOver: boolean;
}

export function createGame(width: number, height: number): GameState {
  const start: Coordinate = { x: Math.floor(width / 2), y: Math.floor(height / 2) };
  return {
    width,
    height,
    snake: [start],
    direction: 'right',
    food: spawnFood([start], width, height),
    isGameOver: false,
  };
}

function spawnFood(snake: Coordinate[], width: number, height: number): Coordinate {
  const food: Coordinate = {
    x: Math.floor(dateRnd() * width),
    y: Math.floor(dateRnd() * height),
  };

  if (collides(snake, food)) {
    return spawnFood(snake, width, height);
  }
  return food;
}

const head = (snake: Coordinate[]): Coordinate => snake[snake.length - 1];

const collides =
  (snake: Coordinate[], coordinate: Coordinate) =>
  snake.some(p => p.x === coordinate.x && p.y === coordinate.y)

const collidesBorder =
  (coordinate: Coordinate, width: number, height: number) =>
  coordinate.x < 0 || coordinate.x >= width || coordinate.y < 0 || coordinate.y >= height;


export function moveSnake(game: GameState): GameState {
  if (game.isGameOver) {
    return game;
  }

  const newHead = getNextPosition(head(game.snake), game.direction);
  const eaten = collides([...game.snake, newHead], game.food);

  const snake = eaten ?
    [...game.snake, newHead] :
    [...game.snake.slice(1), newHead];

  const food = eaten ?
  spawnFood(snake, game.width, game.height) :
  game.food;

  if (collides(snake.slice(0, -1), head(snake)) || collidesBorder(head(snake), game.width, game.height)) {
    return {
      width: game.width,
      height: game.height,
      direction: game.direction,
      snake: game.snake,
      food: game.food,
      isGameOver: true
    }
  }

  return {
    width: game.width,
    height: game.height,
    direction: game.direction,
    snake,
    food,
    isGameOver: game.isGameOver
  };
}

function getNextPosition(head: Coordinate, dir: Direction): Coordinate {
  if (dir === 'up') {
    return { x: head.x, y: head.y - 1 } as Coordinate;
  }
  if (dir === 'down') {
    return { x: head.x, y: head.y + 1 } as Coordinate;
  }
  if (dir === 'left') {
    return { x: head.x - 1, y: head.y } as Coordinate;
  }
  if (dir === 'right') {
    return { x: head.x + 1, y: head.y } as Coordinate;
  }

  throw Error('Impossible.')
}

export function changeDirection(game: GameState, newDir: Direction): GameState {
  const opposite: Record<Direction, Direction> = {
    'up': 'down',
    'down': 'up',
    'left': 'right',
    'right': 'left',
  };
  if (opposite[game.direction] === newDir) {
    return game;
  }
  return {
    width: game.width,
    height: game.height,
    direction: newDir,
    snake: game.snake,
    food: game.food,
    isGameOver: game.isGameOver
  }
}

function dateRnd() {
  return (Date.now() % 1000) / 1000;
}

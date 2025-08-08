export interface Corners {
  roundTopLeft: boolean;
  roundTopRight: boolean;
  roundBottomLeft: boolean;
  roundBottomRight: boolean;
}

export type Direction = 'up' | 'down' | 'left' | 'right';

export interface Coordinate {
  x: number;
  y: number
}
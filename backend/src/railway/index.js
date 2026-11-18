import { env } from '../env.js';
import * as railkitProvider from './railkit.js';
import * as irctcProvider from './irctc.js';
import * as demoProvider from '../demo/index.js';

export const source = env.demo ? 'demo' : env.provider;
export const provider = env.demo
  ? demoProvider
  : env.provider === 'railkit'
    ? railkitProvider
    : irctcProvider;

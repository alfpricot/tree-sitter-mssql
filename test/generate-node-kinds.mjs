// Extracts the sorted list of named node kinds from src/node-types.json and
// writes it to test/node-kinds.txt. This snapshot is this grammar's public
// API surface: consumers match against node kind names directly, so a
// rename or removal here is meant to be an explicit, reviewable diff rather
// than a silent break that only surfaces downstream.

import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));
const nodeTypes = JSON.parse(readFileSync(`${repoRoot}src/node-types.json`, 'utf8'));

const kinds = [...new Set(nodeTypes.filter((node) => node.named).map((node) => node.type))].sort();

writeFileSync(`${repoRoot}test/node-kinds.txt`, `${kinds.join('\n')}\n`);

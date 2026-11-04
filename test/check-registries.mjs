// Checks that every create_*/alter_*/drop_* rule defined anywhere under
// grammar/statements/ actually appears in test/node-kinds.txt (the reachable
// node-kind snapshot). A rule that is defined but never registered in its
// statement's choice() is unreachable from the grammar's start symbol, so it
// never produces a node kind and never parses — completely silent otherwise,
// with no generate-time warning. Checking against node-kinds.txt rather than
// parsing the registry's own source text avoids depending on exact
// formatting (indentation, arrow-function parameter style) that reformatting
// tools are free to change. It also checks the citations in versions.json
// (see the second half of this file).

import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));
const statementsDir = `${repoRoot}grammar/statements/`;

const files = readdirSync(statementsDir).filter((f) => f.endsWith('.js'));

const nodeKinds = new Set(
  readFileSync(`${repoRoot}test/node-kinds.txt`, 'utf8')
    .trim()
    .split('\n')
    .map((line) => line.replace(/\{.*\}$/, '')),
);

const missing = [];

for (const file of files) {
  const source = readFileSync(`${statementsDir}${file}`, 'utf8');
  // A top-level rule definition: `  name: $ => ...` or `  name: ($) => ...`
  // at two-space indent, name not starting with `_` (registries and other
  // hidden helper rules, which don't produce their own node kind).
  for (const match of source.matchAll(/^ {2}(create|alter|drop)_(\w+): \(?\$\)? =>/gm)) {
    const [, prefix, rest] = match;
    const ruleName = `${prefix}_${rest}`;
    if (!nodeKinds.has(ruleName)) {
      missing.push(`${ruleName} (defined in ${file}, not in test/node-kinds.txt)`);
    }
  }
}

// versions.json is written by hand, so check what it cites: every node kind it
// classifies must exist in test/node-kinds.txt, and every corpusCase must name
// a test/corpus file and at least one quoted case title that exists in it.
// A renamed kind or a retitled corpus case would otherwise leave the file
// pointing at nothing.
const versions = JSON.parse(readFileSync(`${repoRoot}versions.json`, 'utf8'));
const corpusTitles = new Map();
function titlesOf(corpusFile) {
  if (!corpusTitles.has(corpusFile)) {
    let source;
    try {
      source = readFileSync(`${repoRoot}${corpusFile}`, 'utf8');
    } catch {
      corpusTitles.set(corpusFile, null);
      return null;
    }
    // A case header is a line of `=`, the title, optional `:attribute` lines,
    // and another line of `=`.
    const titles = new Set();
    for (const match of source.matchAll(/^=+\r?\n(.+?)\r?\n(?::.*\r?\n)*=+\r?$/gm)) {
      titles.add(match[1].trim());
    }
    corpusTitles.set(corpusFile, titles);
  }
  return corpusTitles.get(corpusFile);
}

for (const section of ['nodeKinds', 'deprecated']) {
  for (const [kind, entry] of Object.entries(versions[section] ?? {})) {
    const where = `versions.json ${section}.${kind}`;
    if (!nodeKinds.has(kind)) {
      missing.push(`${where}: not a node kind in test/node-kinds.txt`);
    }
    const citation = entry.corpusCase ?? '';
    const files = [...citation.matchAll(/test\/corpus\/[\w.-]+\.txt/g)].map((m) => m[0]);
    const titles = [...citation.matchAll(/"([^"]+)"/g)].map((m) => m[1]);
    if (files.length !== 1 || titles.length === 0) {
      missing.push(`${where}: corpusCase must name one test/corpus file and a quoted case title`);
      continue;
    }
    const known = titlesOf(files[0]);
    if (known === null) {
      missing.push(`${where}: ${files[0]} does not exist`);
      continue;
    }
    for (const title of titles) {
      if (!known.has(title)) missing.push(`${where}: no case titled "${title}" in ${files[0]}`);
    }
  }
}

if (missing.length > 0) {
  console.error('Registry problems:');
  for (const m of missing) console.error(`  ${m}`);
  process.exit(1);
}

console.log(
  'Every create_*/alter_*/drop_* rule is registered, and every versions.json entry names a real node kind and corpus case.',
);

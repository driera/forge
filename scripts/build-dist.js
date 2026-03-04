#!/usr/bin/env node
// build-dist.js — mirrors skills/ into dist/plugins/ for marketplace distribution
// Run from repo root: node scripts/build-dist.js

import { readdirSync, rmSync, mkdirSync, cpSync, statSync } from 'fs'
import { join } from 'path'

const SKILLS_DIR = 'skills'
const DIST_DIR = 'dist/plugins'

const skills = readdirSync(SKILLS_DIR).filter(name =>
  statSync(join(SKILLS_DIR, name)).isDirectory()
)

console.log('Building dist/plugins/ from skills/...\n')

for (const skillName of skills) {
  const src = join(SKILLS_DIR, skillName)
  const dest = join(DIST_DIR, skillName, 'skills', skillName)

  rmSync(join(DIST_DIR, skillName), { recursive: true, force: true })
  mkdirSync(dest, { recursive: true })
  cpSync(src, dest, { recursive: true })

  console.log(`  ✅ ${skillName}`)
}

console.log('\nDone. dist/plugins/ is up to date.')

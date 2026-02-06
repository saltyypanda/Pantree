-- Enable UUID generation (safe to run multiple times)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- -------------------------
-- Users (minimal)
-- -------------------------
-- Stores Cognito users so we can FK to them
-- Populated via the backend on first login
CREATE TABLE IF NOT EXISTS users (
  user_id     TEXT PRIMARY KEY,   -- Cognito sub
  email       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -------------------------
-- Recipes
-- -------------------------
CREATE TABLE IF NOT EXISTS recipes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       TEXT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,

  title         TEXT NOT NULL,
  description   TEXT,

  -- Free-form structured content
  ingredients   JSONB NOT NULL DEFAULT '{"sections":[]}'::jsonb,
  method        JSONB NOT NULL DEFAULT '{"sections":[]}'::jsonb,

  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Helpful index for listing a user's recipes
CREATE INDEX IF NOT EXISTS idx_recipes_user_id
  ON recipes(user_id);

-- -------------------------
-- Auto-update updated_at
-- -------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recipes_set_updated_at
BEFORE UPDATE ON recipes
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

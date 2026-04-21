const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const fs = require('node:fs');
const path = require('node:path');

const DEFAULT_MONGODB_URI = 'mongodb://127.0.0.1:27017/todos';
const ENV_FILE_PATH = path.join(__dirname, '..', '.env');

function readEnvFileValue(key) {
  if (!fs.existsSync(ENV_FILE_PATH)) {
    return undefined;
  }

  const content = fs.readFileSync(ENV_FILE_PATH, 'utf8');
  const lines = content.split(/\r?\n/);

  for (const line of lines) {
    const trimmedLine = line.trim();
    if (!trimmedLine || trimmedLine.startsWith('#')) {
      continue;
    }

    const separatorIndex = trimmedLine.indexOf('=');
    if (separatorIndex === -1) {
      continue;
    }

    const entryKey = trimmedLine.slice(0, separatorIndex).trim();
    if (entryKey !== key) {
      continue;
    }

    return trimmedLine.slice(separatorIndex + 1).trim();
  }

  return undefined;
}

const MONGODB_URI =
  process.env.MONGODB_URI ||
  readEnvFileValue('MONGODB_URI') ||
  DEFAULT_MONGODB_URI;
const email = (process.env.SEED_USER_EMAIL || 'test@example.com')
  .trim()
  .toLowerCase();
const password = process.env.SEED_USER_PASSWORD || 'password123';
const displayName = (process.env.SEED_USER_DISPLAY_NAME || 'Test User').trim();
const avatarUrl = process.env.SEED_USER_AVATAR_URL?.trim() || undefined;

if (!email || !email.includes('@')) {
  console.error('SEED_USER_EMAIL must be a valid email address');
  process.exit(1);
}

if (!password || password.length < 6) {
  console.error('SEED_USER_PASSWORD must be at least 6 characters');
  process.exit(1);
}

const userSchema = new mongoose.Schema(
  {
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    passwordHash: { type: String },
    displayName: { type: String, required: true, trim: true },
    avatarUrl: { type: String },
    provider: { type: String, enum: ['password', 'google'], required: true },
    googleSub: { type: String, sparse: true, unique: true },
  },
  {
    timestamps: true,
    collection: 'users',
  },
);

const User = mongoose.models.User || mongoose.model('User', userSchema);

async function seedPasswordUser() {
  console.log(`Connecting to MongoDB: ${MONGODB_URI}`);
  await mongoose.connect(MONGODB_URI);

  const passwordHash = await bcrypt.hash(password, 10);
  const user = await User.findOneAndUpdate(
    { email },
    {
      $set: {
        email,
        passwordHash,
        displayName,
        avatarUrl,
        provider: 'password',
      },
    },
    {
      new: true,
      upsert: true,
      setDefaultsOnInsert: true,
    },
  );

  console.log('Seeded password user');
  console.log(`email: ${user.email}`);
  console.log(`displayName: ${user.displayName}`);
  console.log(`provider: ${user.provider}`);
}

seedPasswordUser()
  .catch((error) => {
    console.error('Failed to seed password user');

    if (
      error?.name === 'MongooseServerSelectionError' &&
      /(ECONNREFUSED|EPERM)/.test(String(error?.message))
    ) {
      console.error(
        [
          'MongoDB is not running or is not reachable at the configured URI.',
          `Tried: ${MONGODB_URI}`,
          'Start MongoDB locally, run a MongoDB container, or set MONGODB_URI to the correct server.',
          'Example Docker command:',
          'docker run -d --name todos-mongo -p 27017:27017 mongo:7',
        ].join('\n'),
      );
    } else {
      console.error(error);
    }

    process.exitCode = 1;
  })
  .finally(async () => {
    await mongoose.disconnect();
  });

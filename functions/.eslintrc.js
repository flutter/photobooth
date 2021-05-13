module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:import/errors',
    'plugin:import/warnings',
    'plugin:import/typescript',
    'google',
    'plugin:@typescript-eslint/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: [ 'tsconfig.json', 'tsconfig.dev.json' ],
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  ignorePatterns: [
    '/lib/**/*', // Ignore built files.
  ],
  plugins: [
    '@typescript-eslint',
    'import',
  ],
  rules: {
    'quotes': [ 'error', 'single' ],
    'array-bracket-spacing': [ 'error', 'always' ],
    'object-curly-spacing': [ 'error', 'always' ],
    'max-len': [ 'error', { code: 130, tabWidth: 2 } ],
    'indent': [ 'error', 2 ],
    'no-unused-vars': [ 'warn' ],
    'new-cap': [ 'warn' ],
    'require-jsdoc': [ 0 ],
  },
};

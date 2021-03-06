module.exports = {
  "root": true,
  "env": {
    es6: true,
    node: true,
  },
  "parserOptions": {
    "parser": "babel-eslint",
    "ecmaVersion": 2018,
    "sourceType": "module",
  },
  "extends": [
    "eslint:recommended",
    "google",
  ],
  "rules": {
    quotes: ["error", "double"],
  },

};

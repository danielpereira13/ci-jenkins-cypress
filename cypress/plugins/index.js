const fs = require('fs-extra');
const path = require('path');
const selectTestsWithGrep = require('cypress-select-tests/grep');

/**
 * Reads Cypress configuration for a specific environment
 * @param {string} file The file name.
 * @return {Object} The parsed Cypress configuration.
 */
function getConfigurationByFile(file) {
  const pathToConfigFile = path.resolve('config', `${file}.json`);
  return fs.readJson(pathToConfigFile);
}

module.exports = (on, config) => {
  // setup select tests plugin
  on('file:preprocessor', selectTestsWithGrep(config));

  // accept a configFile value or use local by default
  const file = config.env.configFile || 'local';
  return getConfigurationByFile(file);
};

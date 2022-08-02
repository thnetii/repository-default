/**
 * @param {{
 *  core: import('@actions/core'),
 *  exec: import('@actions/exec'),
 * }} args
 */
module.exports = async ({ core, exec: { exec } }) => {
  /**
   * @param {string[]} args
   * @param {string | null | undefined} option
   * @param {string} inputName
   * @param {import('@actions/core').InputOptions} [inputOptions]
   */
  const addInputToArgs = (args, option, inputName, inputOptions) => {
    const inputValue = core.getInput(inputName, inputOptions);
    if (!inputValue) return;
    if (option) args.push(option);
    args.push(inputValue);
  };

  /** @param {string} name */
  const getBooleanInputOptional = (name) => {
    if (core.getInput(name, { required: false }))
      return core.getBooleanInput(name);
    return undefined;
  };

  const ghCliArgs = ['repo', 'create'];
  addInputToArgs(ghCliArgs, undefined, 'repo-name', { required: true });
  addInputToArgs(ghCliArgs, '--description', 'description');
  const visibility = core.getInput('visibility');
  if (visibility) {
    ghCliArgs.push(`--${visibility}`);
  }
  if (getBooleanInputOptional('disable-issues')) {
    ghCliArgs.push('--disable-issues');
  }
  if (getBooleanInputOptional('disable-wiki')) {
    ghCliArgs.push('--disable-wiki');
  }
  addInputToArgs(ghCliArgs, '--gitignore', 'gitignore');
  addInputToArgs(ghCliArgs, '--license', 'license');

  await exec('gh', ghCliArgs);
};


function actionWrite( frame )
{
  const run = frame.run;
  const module = run.module;
  const will = module.will;
  const fileProvider = will.fileProvider;
  const logger = will.transaction.logger;
  const opener = module.toOpener();

  /* */

  logger.log( `Updating willfile. Setup version "${ module.about.version }".` );

  const commonPath = fileProvider.path.common( opener.openedModule.willfilesPath );
  will.willfilePropertySet
  ({
    commonPath,
    request: '',
    selectorsMap: { 'about/version' : module.about.version },
  });

  /* */

  const actionPath = fileProvider.path.join( module.dirPath, 'action.yml' );
  const action = fileProvider.fileReadUnknown( actionPath );
  action.runs.steps[ 0 ].uses = `gmsllc/wretry.action@js_action`;

  logger.log( `Updating action. Setup used action version to "gmsllc/wretry.action@js_action".` );

  fileProvider.fileWrite({ filePath : actionPath, data : action, encoding : 'yaml' });
}

module.exports = actionWrite;

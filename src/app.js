"use strict";

exports.lambdaHandler = async (event, context) => {

  return {
    'statusCode': 200,
    'body': 'hello world'
  };
};

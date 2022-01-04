"use strict";

exports.lambdaHandler = async (event, context) => {

  let claims=event.requestContext.authorizer.claims;

  return {
    'statusCode': 200,
    'body': `Hello, ${claims.given_name} ${claims.family_name} <${claims.email}> !!\n`
  };
};
